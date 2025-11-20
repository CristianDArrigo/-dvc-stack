<template>
  <div class="hello-django">
    
    <div class="content-wrapper">
      <transition name="fade" mode="out-in">
        <div v-if="loading" class="loading" key="loading">
          <div class="spinner"></div>
          <span>Caricamento...</span>
        </div>
        
        <div v-else-if="error" class="error" key="error">
          <div class="error-icon">⚠️</div>
          <div class="error-content">
            <p class="error-message">{{ error }}</p>
            <p class="error-details" v-if="errorDetails">{{ errorDetails }}</p>
          </div>
          <button @click="fetchMessage" class="retry-btn" :disabled="loading">
            <span v-if="loading">Caricamento...</span>
            <span v-else>🔄 Riprova</span>
          </button>
        </div>
        
        <div v-else class="success" key="success">
          <div class="success-icon">✅</div>
          <div class="message-content">
            <p class="message">{{ message }}</p>
            <small class="timestamp">Ultimo aggiornamento: {{ lastUpdated }}</small>
          </div>
          <button @click="fetchMessage" class="refresh-btn" :disabled="loading">
            <span v-if="loading">⏳</span>
            <span v-else>🔄</span>
            Aggiorna
          </button>
        </div>
      </transition>
    </div>
    
    <div class="footer">
      <small>Tentativi: {{ attempts }} | Stato: {{ connectionStatus }}</small>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "HelloDjango",
  data() {
    return { 
      message: "", 
      loading: true,
      error: null,
      errorDetails: null,
      lastUpdated: null,
      attempts: 0,
      connectionStatus: 'connecting'
    };
  },
  computed: {
    statusClass() {
      if (this.loading) return 'loading';
      if (this.error) return 'error';
      return 'success';
    }
  },
  mounted() {
    this.fetchMessage();
  },
  methods: {
    async fetchMessage() {
      this.loading = true;
      this.error = null;
      this.errorDetails = null;
      this.attempts++;
      this.connectionStatus = 'connecting';
      
      try {
        const response = await axios.get("http://127.0.0.1:8000/api/hello/", {
          timeout: 10000,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
        });
        
        this.message = response.data.message;
        this.lastUpdated = new Date().toLocaleTimeString('it-IT');
        this.connectionStatus = 'connected';
        
      } catch (err) {
        this.connectionStatus = 'error';
        
        if (err.code === 'ECONNABORTED') {
          this.error = "Timeout: Il server non risponde";
          this.errorDetails = "Verifica che il backend sia avviato";
        } else if (err.response) {
          this.error = err.response.data?.error || `Errore ${err.response.status}`;
          this.errorDetails = err.response.statusText;
        } else if (err.request) {
          this.error = "Errore di connessione";
          this.errorDetails = "Impossibile raggiungere il server";
        } else {
          this.error = "Errore imprevisto";
          this.errorDetails = err.message;
        }
      } finally {
        this.loading = false;
      }
    }
  }
};
</script>

<style scoped>
.hello-django {
  padding: 24px;
  max-width: 600px;
  margin: 0 auto;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
}

.header h2 {
  margin: 0;
  color: #2c3e50;
}

.status-indicator {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  transition: all 0.3s ease;
}

.status-indicator.loading {
  background-color: #ffc107;
  animation: pulse 2s infinite;
}

.status-indicator.error {
  background-color: #dc3545;
}

.status-indicator.success {
  background-color: #28a745;
}

.content-wrapper {
  min-height: 120px;
  position: relative;
}

.loading, .error, .success {
  padding: 20px;
  border-radius: 8px;
  margin: 15px 0;
  display: flex;
  align-items: center;
  gap: 15px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  transition: all 0.3s ease;
}

.loading {
  background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
  border-left: 4px solid #2196f3;
}

.error {
  background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
  border-left: 4px solid #f44336;
  color: #c62828;
  flex-direction: column;
  align-items: flex-start;
}

.success {
  background: linear-gradient(135deg, #f1f8e9 0%, #dcedc8 100%);
  border-left: 4px solid #4caf50;
  flex-direction: column;
  align-items: flex-start;
}

.spinner {
  width: 20px;
  height: 20px;
  border: 2px solid #e3f2fd;
  border-top: 2px solid #2196f3;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

.error-content, .message-content {
  flex: 1;
}

.error-icon, .success-icon {
  font-size: 24px;
  margin-right: 10px;
}

.error-message, .message {
  margin: 0 0 5px 0;
  font-weight: 500;
}

.error-details, .timestamp {
  margin: 0;
  font-size: 0.9em;
  opacity: 0.7;
}

.retry-btn, .refresh-btn {
  margin-top: 15px;
  padding: 10px 20px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 500;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 5px;
}

.retry-btn {
  background: linear-gradient(135deg, #f44336 0%, #d32f2f 100%);
  color: white;
}

.refresh-btn {
  background: linear-gradient(135deg, #2196f3 0%, #1976d2 100%);
  color: white;
}

.retry-btn:hover:not(:disabled), 
.refresh-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.2);
}

.retry-btn:disabled, 
.refresh-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
}

.footer {
  text-align: center;
  margin-top: 20px;
  padding-top: 15px;
  border-top: 1px solid #eee;
  color: #666;
}

/* Animations */
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from, .fade-leave-to {
  opacity: 0;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

/* Responsive */
@media (max-width: 768px) {
  .hello-django {
    padding: 16px;
  }
  
  .header {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
  
  .loading, .error, .success {
    padding: 15px;
  }
}
</style>
