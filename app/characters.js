// characters.js — Animated pixel characters for each DataQuest level
// Each character is drawn with CSS + div animations — no images needed

function createCharacter(levelIndex, container, size = 80) {
  const colors = [
    { body: '#94a3b8', accent: '#64748b', eye: '#1e293b' },  // 0 Data Padawan
    { body: '#a78bfa', accent: '#7c3aed', eye: '#1e293b' },  // 1 Query Rookie
    { body: '#60a5fa', accent: '#2563eb', eye: '#1e293b' },  // 2 Table Builder
    { body: '#34d399', accent: '#059669', eye: '#1e293b' },  // 3 Join Warrior
    { body: '#fbbf24', accent: '#d97706', eye: '#1e293b' },  // 4 Schema Architect
    { body: '#f97316', accent: '#c2410c', eye: '#fff' },     // 5 Index Master
    { body: '#ef4444', accent: '#b91c1c', eye: '#fff' },     // 6 Database Sensei
    { body: '#ec4899', accent: '#be185d', eye: '#fff' },     // 7 Data Wizard
    { body: '#8b5cf6', accent: '#6d28d9', eye: '#fbbf24' },  // 8 SQL Overlord
  ];
  
  const hats = ['none', 'cap', 'headband', 'helmet', 'crown-small', 'wizard-hat', 'sensei-band', 'wizard-hat-star', 'crown-big'];
  const accessories = ['none', 'none', 'hammer', 'sword', 'compass', 'scroll', 'staff', 'wand', 'scepter'];
  
  const c = colors[Math.min(levelIndex, colors.length - 1)];
  const hat = hats[Math.min(levelIndex, hats.length - 1)];
  const acc = accessories[Math.min(levelIndex, accessories.length - 1)];
  const s = size / 80; // scale factor
  
  const el = document.createElement('div');
  el.className = 'dq-char';
  el.style.cssText = `width:${size}px;height:${size + 20*s}px;position:relative;`;
  
  let hatHTML = '';
  switch(hat) {
    case 'cap':
      hatHTML = `<div style="position:absolute;top:${2*s}px;left:${14*s}px;width:${52*s}px;height:${14*s}px;background:${c.accent};border-radius:${6*s}px ${6*s}px ${2*s}px ${2*s}px"></div>
                 <div style="position:absolute;top:${10*s}px;left:${8*s}px;width:${40*s}px;height:${6*s}px;background:${c.accent};border-radius:${3*s}px"></div>`;
      break;
    case 'headband':
      hatHTML = `<div style="position:absolute;top:${8*s}px;left:${12*s}px;width:${56*s}px;height:${6*s}px;background:${c.accent};border-radius:${3*s}px"></div>
                 <div style="position:absolute;top:${4*s}px;right:${12*s}px;width:${8*s}px;height:${14*s}px;background:${c.accent};border-radius:${2*s}px;transform:rotate(20deg)"></div>`;
      break;
    case 'helmet':
      hatHTML = `<div style="position:absolute;top:${0*s}px;left:${16*s}px;width:${48*s}px;height:${22*s}px;background:${c.accent};border-radius:${24*s}px ${24*s}px ${4*s}px ${4*s}px"></div>
                 <div style="position:absolute;top:${6*s}px;left:${36*s}px;width:${6*s}px;height:${10*s}px;background:#fbbf24;border-radius:${2*s}px"></div>`;
      break;
    case 'crown-small':
      hatHTML = `<div style="position:absolute;top:${2*s}px;left:${18*s}px;width:${44*s}px;height:${12*s}px;background:#fbbf24;clip-path:polygon(0% 100%, 10% 0%, 25% 60%, 50% 0%, 75% 60%, 90% 0%, 100% 100%)"></div>`;
      break;
    case 'wizard-hat':
      hatHTML = `<div style="position:absolute;top:${-12*s}px;left:${20*s}px;width:${40*s}px;height:${30*s}px;background:${c.accent};clip-path:polygon(50% 0%, 0% 100%, 100% 100%)"></div>`;
      break;
    case 'sensei-band':
      hatHTML = `<div style="position:absolute;top:${4*s}px;left:${10*s}px;width:${60*s}px;height:${8*s}px;background:#ef4444;border-radius:${2*s}px"></div>
                 <div style="position:absolute;top:${-2*s}px;left:${34*s}px;width:${16*s}px;height:${16*s}px;background:#ef4444;border-radius:50%;border:${2*s}px solid #fff"></div>`;
      break;
    case 'wizard-hat-star':
      hatHTML = `<div style="position:absolute;top:${-16*s}px;left:${18*s}px;width:${44*s}px;height:${34*s}px;background:${c.accent};clip-path:polygon(50% 0%, 0% 100%, 100% 100%)"></div>
                 <div style="position:absolute;top:${-8*s}px;left:${34*s}px;font-size:${14*s}px">⭐</div>`;
      break;
    case 'crown-big':
      hatHTML = `<div style="position:absolute;top:${-4*s}px;left:${14*s}px;width:${52*s}px;height:${18*s}px;background:linear-gradient(#fbbf24,#f59e0b);clip-path:polygon(0% 100%, 5% 0%, 20% 50%, 35% 0%, 50% 50%, 65% 0%, 80% 50%, 95% 0%, 100% 100%)"></div>
                 <div style="position:absolute;top:${0*s}px;left:${36*s}px;width:${8*s}px;height:${8*s}px;background:#ef4444;border-radius:50%"></div>`;
      break;
  }
  
  let accHTML = '';
  switch(acc) {
    case 'hammer':
      accHTML = `<div class="dq-acc" style="position:absolute;bottom:${20*s}px;right:${-4*s}px;width:${6*s}px;height:${28*s}px;background:#92400e;border-radius:${2*s}px;transform-origin:bottom center"></div>
                 <div class="dq-acc" style="position:absolute;bottom:${44*s}px;right:${-10*s}px;width:${18*s}px;height:${10*s}px;background:#71717a;border-radius:${2*s}px"></div>`;
      break;
    case 'sword':
      accHTML = `<div class="dq-acc" style="position:absolute;bottom:${18*s}px;right:${-2*s}px;width:${4*s}px;height:${34*s}px;background:#d1d5db;border-radius:${1*s}px"></div>
                 <div class="dq-acc" style="position:absolute;bottom:${32*s}px;right:${-8*s}px;width:${16*s}px;height:${4*s}px;background:#92400e;border-radius:${1*s}px"></div>`;
      break;
    case 'compass':
      accHTML = `<div class="dq-acc" style="position:absolute;bottom:${24*s}px;right:${-6*s}px;width:${18*s}px;height:${18*s}px;background:#1e3a5f;border-radius:50%;border:${2*s}px solid #fbbf24"></div>
                 <div style="position:absolute;bottom:${30*s}px;right:${0*s}px;width:${2*s}px;height:${8*s}px;background:#ef4444;transform:rotate(30deg)"></div>`;
      break;
    case 'scroll':
      accHTML = `<div class="dq-acc" style="position:absolute;bottom:${22*s}px;right:${-8*s}px;width:${20*s}px;height:${24*s}px;background:#fef3c7;border-radius:${3*s}px;border:${1*s}px solid #d97706"></div>`;
      break;
    case 'staff':
      accHTML = `<div class="dq-acc" style="position:absolute;bottom:${10*s}px;right:${-4*s}px;width:${5*s}px;height:${50*s}px;background:#92400e;border-radius:${2*s}px"></div>
                 <div style="position:absolute;bottom:${56*s}px;right:${-8*s}px;width:${14*s}px;height:${14*s}px;background:#ef4444;border-radius:50%;box-shadow:0 0 ${8*s}px #ef4444"></div>`;
      break;
    case 'wand':
      accHTML = `<div class="dq-acc" style="position:absolute;bottom:${18*s}px;right:${-2*s}px;width:${4*s}px;height:${36*s}px;background:linear-gradient(#d4d4d8,#71717a);border-radius:${2*s}px;transform:rotate(-10deg)"></div>
                 <div style="position:absolute;bottom:${50*s}px;right:${-4*s}px;font-size:${10*s}px;animation:sparkle 1s infinite">✨</div>`;
      break;
    case 'scepter':
      accHTML = `<div class="dq-acc" style="position:absolute;bottom:${10*s}px;right:${-4*s}px;width:${6*s}px;height:${52*s}px;background:linear-gradient(#fbbf24,#92400e);border-radius:${3*s}px"></div>
                 <div style="position:absolute;bottom:${58*s}px;right:${-8*s}px;width:${18*s}px;height:${18*s}px;background:#8b5cf6;border-radius:${4*s}px;transform:rotate(45deg);box-shadow:0 0 ${12*s}px #8b5cf6"></div>`;
      break;
  }
  
  el.innerHTML = `
    ${hatHTML}
    <!-- Head -->
    <div style="position:absolute;top:${14*s}px;left:${18*s}px;width:${44*s}px;height:${38*s}px;background:${c.body};border-radius:${16*s}px ${16*s}px ${12*s}px ${12*s}px"></div>
    <!-- Eyes -->
    <div class="dq-eyes" style="position:absolute;top:${28*s}px;left:${26*s}px;display:flex;gap:${12*s}px">
      <div style="width:${8*s}px;height:${10*s}px;background:${c.eye};border-radius:${3*s}px"></div>
      <div style="width:${8*s}px;height:${10*s}px;background:${c.eye};border-radius:${3*s}px"></div>
    </div>
    <!-- Mouth -->
    <div style="position:absolute;top:${42*s}px;left:${32*s}px;width:${16*s}px;height:${6*s}px;border-bottom:${3*s}px solid ${c.eye};border-radius:0 0 ${8*s}px ${8*s}px"></div>
    <!-- Body -->
    <div style="position:absolute;top:${52*s}px;left:${22*s}px;width:${36*s}px;height:${28*s}px;background:${c.accent};border-radius:${8*s}px ${8*s}px ${10*s}px ${10*s}px"></div>
    <!-- Arms -->
    <div class="dq-arm-l" style="position:absolute;top:${54*s}px;left:${10*s}px;width:${14*s}px;height:${8*s}px;background:${c.body};border-radius:${4*s}px;transform-origin:right center"></div>
    <div class="dq-arm-r" style="position:absolute;top:${54*s}px;right:${10*s}px;width:${14*s}px;height:${8*s}px;background:${c.body};border-radius:${4*s}px;transform-origin:left center"></div>
    <!-- Legs -->
    <div class="dq-leg-l" style="position:absolute;bottom:${0}px;left:${24*s}px;width:${12*s}px;height:${16*s}px;background:${c.body};border-radius:0 0 ${4*s}px ${4*s}px;transform-origin:top center"></div>
    <div class="dq-leg-r" style="position:absolute;bottom:${0}px;right:${24*s}px;width:${12*s}px;height:${16*s}px;background:${c.body};border-radius:0 0 ${4*s}px ${4*s}px;transform-origin:top center"></div>
    ${accHTML}
  `;
  
  if (container) container.appendChild(el);
  return el;
}

// Inject global animation CSS
(function() {
  if (document.getElementById('dq-char-styles')) return;
  const style = document.createElement('style');
  style.id = 'dq-char-styles';
  style.textContent = `
    @keyframes dqDance {
      0%,100% { transform: translateY(0) rotate(0deg); }
      15% { transform: translateY(-8px) rotate(-8deg); }
      30% { transform: translateY(-2px) rotate(0deg); }
      45% { transform: translateY(-8px) rotate(8deg); }
      60% { transform: translateY(-2px) rotate(0deg); }
      75% { transform: translateY(-6px) rotate(-5deg); }
    }
    @keyframes dqBounce {
      0%,100% { transform: translateY(0); }
      50% { transform: translateY(-6px); }
    }
    @keyframes dqWave {
      0%,100% { transform: rotate(0deg); }
      25% { transform: rotate(-25deg); }
      75% { transform: rotate(15deg); }
    }
    @keyframes dqBlink {
      0%,90%,100% { transform: scaleY(1); }
      95% { transform: scaleY(0.1); }
    }
    @keyframes sparkle {
      0%,100% { opacity: 1; transform: scale(1) rotate(0deg); }
      50% { opacity: 0.5; transform: scale(1.3) rotate(180deg); }
    }
    .dq-char.dancing { animation: dqDance 1.2s ease-in-out infinite; }
    .dq-char.bouncing { animation: dqBounce 0.8s ease-in-out infinite; }
    .dq-char .dq-eyes { animation: dqBlink 4s ease-in-out infinite; }
    .dq-char.dancing .dq-arm-l { animation: dqWave 0.6s ease-in-out infinite; }
    .dq-char.dancing .dq-arm-r { animation: dqWave 0.6s ease-in-out infinite 0.3s; }
    .dq-char.dancing .dq-leg-l { animation: dqWave 0.6s ease-in-out infinite 0.15s; }
    .dq-char.dancing .dq-leg-r { animation: dqWave 0.6s ease-in-out infinite 0.45s; }
  `;
  document.head.appendChild(style);
})();
