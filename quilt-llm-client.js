/**
 * quilt-llm-client.js — Shared browser-side LLM client for the Quilt pages.
 *
 * Drop this <script src="quilt-llm-client.js"></script> in any page.
 * It exposes a global `quiltLLM` object with:
 *   - quiltLLM.call(messages, opts)         — calls the Worker (or falls back to direct)
 *   - quiltLLM.status()                     — returns current rate-limit status
 *   - quiltLLM.setWorkerUrl(url)            — configures the Worker URL
 *   - quiltLLM.onLimitHit(callback)         — register a callback for 429 responses
 *
 * Behavior:
 *   1. If localStorage has 'quilt_worker_url', call the Worker there
 *   2. Otherwise, fall back to direct provider calls using keys in localStorage
 *   3. If the call returns 429 (rate limit), show a graceful "limit hit" page
 *
 * Author: Mavis
 * Date: 2026-08-20
 */

(function() {
  'use strict';

  // ---------------------------------------------------------------------
  // Storage
  // ---------------------------------------------------------------------
  function getConfig() {
    return {
      workerUrl: localStorage.getItem('quilt_worker_url') || null,
      zaiKey: localStorage.getItem('zai_key') || (typeof ZAI_TOKEN !== 'undefined' ? ZAI_TOKEN : null),
      kimiKey: localStorage.getItem('kimi_key') || (typeof KIMI_TOKEN !== 'undefined' ? KIMI_TOKEN : null),
      dsKey: localStorage.getItem('ds_key') || (typeof DEEPSEEK_TOKEN !== 'undefined' ? DEEPSEEK_TOKEN : null),
    };
  }

  // ---------------------------------------------------------------------
  // Direct provider calls (fallback when no Worker)
  // ---------------------------------------------------------------------
  async function callDirect(messages, opts) {
    const cfg = getConfig();
    const provider = opts.provider || 'workers-ai';

    // If user wants zai and has a key
    if ((provider === 'zai' || provider === 'glm-5' || provider === 'glm-5.3') && cfg.zaiKey) {
      const model = opts.model || (provider === 'glm-5.3' ? 'glm-5.3' : 'glm-5');
      const resp = await fetch('https://api.z.ai/api/paas/v4/chat/completions', {
        method: 'POST',
        headers: {
          'Authorization': 'Bearer ' + cfg.zaiKey,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ model, messages, max_tokens: opts.max_tokens || 2000, temperature: opts.temperature ?? 0.7 }),
      });
      if (!resp.ok) throw new Error('z.ai HTTP ' + resp.status);
      const data = await resp.json();
      return { content: data.choices[0].message.content, model, provider: 'zai' };
    }

    if (provider === 'kimi' || provider === 'kimi-k3') {
      if (!cfg.kimiKey) throw new Error('Kimi key not set');
      const resp = await fetch('https://api.moonshot.ai/v1/chat/completions', {
        method: 'POST',
        headers: {
          'Authorization': 'Bearer ' + cfg.kimiKey,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ model: 'kimi-k3', messages, max_tokens: opts.max_tokens || 2000, temperature: 1.0 }),
      });
      if (!resp.ok) throw new Error('Kimi HTTP ' + resp.status);
      const data = await resp.json();
      return { content: data.choices[0].message.content, model: 'kimi-k3', provider: 'kimi' };
    }

    if (provider === 'deepseek' || provider === 'ds') {
      if (!cfg.dsKey) throw new Error('DeepSeek key not set');
      const resp = await fetch('https://api.deepseek.com/v1/chat/completions', {
        method: 'POST',
        headers: {
          'Authorization': 'Bearer ' + cfg.dsKey,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ model: 'deepseek-chat', messages, max_tokens: opts.max_tokens || 2000, temperature: opts.temperature ?? 0.7 }),
      });
      if (!resp.ok) throw new Error('DeepSeek HTTP ' + resp.status);
      const data = await resp.json();
      return { content: data.choices[0].message.content, model: 'deepseek-chat', provider: 'deepseek' };
    }

    throw new Error('No LLM available. Set localStorage.zai_key or configure a Worker URL (localStorage.quilt_worker_url).');
  }

  // ---------------------------------------------------------------------
  // Worker call (preferred)
  // ---------------------------------------------------------------------
  async function callWorker(messages, opts) {
    const cfg = getConfig();
    if (!cfg.workerUrl) {
      throw new Error('No Worker URL configured. Set localStorage.quilt_worker_url or pass your own API keys.');
    }

    const url = cfg.workerUrl.replace(/\/$/, '') + '/v1/chat/completions';
    const resp = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        messages,
        provider: opts.provider || 'workers-ai',
        model: opts.model,
        max_tokens: opts.max_tokens || 2000,
        temperature: opts.temperature ?? 0.7,
        prefer_cheap: opts.prefer_cheap !== false,  // default true
        premium: opts.premium === true,  // default false
      }),
    });

    if (resp.status === 429) {
      // Rate limit hit — show graceful page
      const body = await resp.json().catch(() => ({}));
      showLimitHit(body);
      const err = new Error('rate_limit');
      err.rateLimit = body;
      throw err;
    }

    if (!resp.ok) {
      const err = await resp.text();
      throw new Error('Worker HTTP ' + resp.status + ': ' + err.slice(0, 200));
    }

    return await resp.json();
  }

  // ---------------------------------------------------------------------
  // Graceful 429 page
  // ---------------------------------------------------------------------
  function showLimitHit(body) {
    const params = new URLSearchParams();
    if (body.reason) params.set('reason', body.reason);
    if (body.limit) params.set('limit', body.limit);
    if (body.usedToday) params.set('used', body.usedToday);
    // Open the limit-hit page in the same window
    window.location.href = '/limit-hit.html?' + params.toString();
  }

  // ---------------------------------------------------------------------
  // Status (calls Worker /status endpoint)
  // ---------------------------------------------------------------------
  async function status() {
    const cfg = getConfig();
    if (!cfg.workerUrl) {
      return { ok: false, message: 'No Worker URL configured.' };
    }
    const url = cfg.workerUrl.replace(/\/$/, '') + '/status';
    const resp = await fetch(url);
    if (!resp.ok) {
      return { ok: false, status: resp.status };
    }
    return await resp.json();
  }

  // ---------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------
  async function call(messages, opts = {}) {
    const cfg = getConfig();
    // Prefer Worker if configured
    if (cfg.workerUrl) {
      try {
        return await callWorker(messages, opts);
      } catch (e) {
        if (e.rateLimit) throw e;  // Already handled (page navigated)
        // If Worker is down, try direct as fallback
        if (cfg.zaiKey || cfg.kimiKey || cfg.dsKey) {
          console.warn('Worker failed, falling back to direct:', e.message);
          return await callDirect(messages, opts);
        }
        throw e;
      }
    }
    // Direct only
    return await callDirect(messages, opts);
  }

  function setWorkerUrl(url) {
    localStorage.setItem('quilt_worker_url', url);
  }

  // ---------------------------------------------------------------------
  // Export
  // ---------------------------------------------------------------------
  window.quiltLLM = {
    call,
    status,
    setWorkerUrl,
    showLimitHit,
  };
})();
