<script setup>
import { ref, computed } from 'vue';

const inputMinutes = ref(1);
const inputSeconds = ref(0);
const remainingSeconds = ref(0);
const timerInterval = ref(null);
const status = ref('idle');

const formattedTime = computed(() => {
  const minutes = Math.floor(remainingSeconds.value / 60);
  const seconds = remainingSeconds.value % 60;
  return `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
});

function clearTimerInterval() {
  if (timerInterval.value) {
    clearInterval(timerInterval.value);
    timerInterval.value = null;
  }
}

function startTimer() {
  const total = (inputMinutes.value * 60) + inputSeconds.value;
  if (total <= 0) return;

  remainingSeconds.value = total;
  status.value = 'running';

  clearTimerInterval();
  timerInterval.value = setInterval(() => {
    remainingSeconds.value--;
    if (remainingSeconds.value <= 0) {
      clearTimerInterval();
      status.value = 'finished';
    }
  }, 1000);
}

function pauseTimer() {
  clearTimerInterval();
  status.value = 'paused';
}

function resumeTimer() {
  status.value = 'running';
  clearTimerInterval();
  timerInterval.value = setInterval(() => {
    remainingSeconds.value--;
    if (remainingSeconds.value <= 0) {
      clearTimerInterval();
      status.value = 'finished';
    }
  }, 1000);
}

function resetTimer() {
  clearTimerInterval();
  status.value = 'idle';
  inputMinutes.value = 1;
  inputSeconds.value = 0;
  remainingSeconds.value = 0;
}
</script>

<template>
  <main class="monster-app">
    <div class="timer-display-wrapper">
      <div class="time-display" :class="{ finished: status === 'finished' }">
        <span v-if="status === 'idle'">
          {{ String(inputMinutes).padStart(2, '0') }}:{{ String(inputSeconds).padStart(2, '0') }}
        </span>
        <span v-else>{{ formattedTime }}</span>
      </div>
      <div class="finished-message" :style="{ opacity: status === 'finished' ? 1 : 0 }">SÜRE DOLDU</div>
    </div>

    <div class="controls-wrapper">
      <div v-if="status === 'idle'" class="settings">
        <div class="input-group">
          <label>Dakika</label>
          <input v-model="inputMinutes" type="number" min="0" max="99" />
        </div>
        <div class="input-group">
          <label>Saniye</label>
          <input v-model="inputSeconds" type="number" min="0" max="59" />
        </div>
        <div class="input-group">
          <label>&nbsp;</label>
          <button @click="startTimer" class="btn btn-primary">Başlat</button>
        </div>
      </div>

      <div v-else class="controls">
        <button v-if="status === 'running'" @click="pauseTimer" class="btn btn-secondary">Durdur</button>
        <button v-if="status === 'paused'" @click="resumeTimer" class="btn btn-primary">Devam Et</button>
        <button @click="resetTimer" class="btn btn-secondary">Sıfırla</button>
      </div>
    </div>
  </main>
</template>

<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap');

:root {
  --bg-color: #121212;
  --card-bg-color: #2a2a2a;
  --text-color: #e0e0e0;
  --text-color-muted: #888;
  --border-color: #444;
  --monster-green-primary: #00ff7f;
  --monster-green-dark-hover: #6a994e;
  --monster-green-glow: rgba(0, 255, 127, 0.4);
}

body {
  margin: 0;
  font-family: 'Inter', sans-serif;
  background-color: var(--bg-color);
  color: var(--text-color);
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.monster-app {
  display: flex;
  flex-direction: column;
  align-items: center;
  min-height: 100vh;
  padding: 2rem;
  box-sizing: border-box;
}

.timer-display-wrapper {
  flex-grow: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  width: 100%;
}

.time-display {
  font-family: 'Courier New', Courier, monospace;
  font-weight: 700;
  color: var(--text-color);
  font-size: clamp(4rem, 20vw, 22rem);
  transition: color 0.3s ease-in-out;
}

.time-display.finished {
  color: var(--monster-green-primary);
  text-shadow: 0 0 20px var(--monster-green-glow);
}

.finished-message {
  color: var(--monster-green-primary);
  font-size: clamp(1.5rem, 5vw, 2.5rem);
  font-weight: 700;
  margin-top: 1rem;

  transition: opacity 0.5s ease-in-out;
  height: clamp(1.5rem, 5vw, 2.5rem);
  line-height: 1;
}

.controls-wrapper {
  width: 100%;
  max-width: 500px;
  padding-top: 1rem;
  min-height: 100px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.settings,
.controls {
  display: flex;
  gap: 1rem;
  justify-content: center;
  align-items: flex-end;
  width: 100%;
}

.input-group {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
}

.input-group label {
  font-size: 0.8rem;
  color: var(--text-color-muted);
}

.input-group input {
  background-color: var(--card-bg-color);
  border: 1px solid var(--border-color);
  color: var(--text-color);
  border-radius: 8px;
  padding: 0.8rem;
  font-size: 1.2rem;
  width: 70px;
  text-align: center;
}

.input-group input:focus {
  outline: 2px solid var(--monster-green-primary);
  outline-offset: 2px;
}

.btn {
  padding: 0.8rem 1.5rem;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s ease-in-out;
  white-space: nowrap;
}

.btn-primary {
  background-color: var(--monster-green-primary);
  color: var(--bg-color);
  border: 1px solid var(--monster-green-primary);
}

.btn-primary:hover {
  background-color: white;
  border-color: white;
  color: var(--bg-color);
}

.btn-secondary {
  background-color: transparent;
  color: var(--monster-green-primary);
  border: 1px solid var(--monster-green-primary);
}

.btn-secondary:hover {
  background-color: var(--monster-green-dark-hover);
  color: var(--text-color);
  border-color: var(--monster-green-dark-hover);
}

@media (max-width: 600px) {

  .settings,
  .controls {
    flex-direction: column;
    /* Yan yana dizmek yerine alt alta diz */
    align-items: center;
    /* Dikey eksende ortala */
    gap: 1.2rem;
    /* Aralarındaki dikey boşluğu biraz artıralım */
  }

  .input-group {
    width: 100%;
    /* Dikeyde hizalanan grupların tam genişlikte olmasını sağla */
  }

  .input-group input {
    width: 100px;
    /* Inputların genişliği sabit kalabilir, şık duruyor */
  }

  .btn {
    width: 90%;
    /* Butonlar ekranın çoğunu kaplasın */
    max-width: 320px;
    /* Ama çok da büyümesinler */
    box-sizing: border-box;
    /* Padding'in genişliği etkilememesi için önemli */
    padding: 1rem 1.5rem;
    /* Mobil için dokunma alanını büyütelim */
  }

  .controls {
    flex-direction: row;
    /* Çalışma sırasındaki butonlar yan yana daha iyi durabilir */
    flex-wrap: wrap;
    /* Ama sığmazlarsa alt satıra atsınlar */
    width: 100%;
  }
}
</style>