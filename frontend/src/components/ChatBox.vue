<template>
  <div class="chat-box">
    <!-- Chat bar -->
    <v-card
      v-if="!isOpen"
      class="chat-bar"
      color="#3e0054"
      @click="isOpen = true"
      elevation="4"
      role="button"
    >
      <div class="d-flex align-center px-4 py-2">
        <v-icon color="white" class="mr-2">mdi-chat</v-icon>
        <span class="text-white bitstream">Chat with AI Assistant</span>
      </div>
    </v-card>

    <!-- Chat window -->
    <v-card v-else class="chat-window" color="#3e0054">
      <v-card-title class="chat-header d-flex align-center">
        <span class="text-white bitstream">AI Build Assistant</span>
        <v-spacer></v-spacer>
        <v-btn icon="mdi-close" variant="text" color="white" @click="isOpen = false"></v-btn>
      </v-card-title>

      <v-card-text class="chat-messages">
        <div v-for="msg in chatHistory" :key="msg.timestamp" 
            :class="['message', msg.type === 'user' ? 'user-message' : 'bot-message']">
          <div class="message-content">
            <p class="bitstream mb-2 text-black">{{ msg.content }}</p>
            <p v-if="msg.totalPrice" class="bitstream text-subtitle-2 text-black"> Total: RM{{ msg.totalPrice.toFixed(2) }} </p>
          </div>
        </div>
    
        <div v-if="loading" class="loading-indicator">
          <v-progress-circular indeterminate color="#e324bd"></v-progress-circular>
        </div>
      </v-card-text>

      <v-card-actions class="chat-input">
        <v-text-field
          v-model="message"
          placeholder="e.g., Build me a PC with RM5000 budget"
          :disabled="loading"
          @keyup.enter="sendMessage"
          hide-details
          class="bitstream chat-input-field"
          bg-color="#1b0224"
          rounded="lg"
        >
          <template v-slot:append>
            <v-btn
              :loading="loading"
              :disabled="!message"
              color="#e324bd"
              icon="mdi-send"
              variant="flat"
              @click="sendMessage"
            ></v-btn>
          </template>
        </v-text-field>
      </v-card-actions>
    </v-card>
  </div>
  </template>
  
<script setup lang="ts">
  import { ref } from 'vue';
  import { useCartStore } from '@/stores/cartstore';
  import useApi from '@/composables/useApi';

  interface ChatMessage {
    type: 'user' | 'bot';
    content: string;
    timestamp: number;
    totalPrice?: number;
    products?: any[];
  }

  interface ChatResponse {
    message: string;
    total_price: number;
    recommended_products?: any[];
  }


  const api = useApi();
  const cartStore = useCartStore();
  
  const isOpen = ref(false);
  const message = ref('');
  const loading = ref(false);

  const response = ref<ChatResponse | null>(null);
  const chatHistory = ref<ChatMessage[]>([]);
  
  const sendMessage = async () => {
    if (!message.value || loading.value) return;

    const userMessage: ChatMessage = {
      type: 'user',
      content: message.value,
      timestamp: Date.now()
    };
  
    chatHistory.value.push(userMessage);
    loading.value = true;

    try {
      const { data } = await api.post('/chatbot/chat/', {
        message: message.value
      });
    
      const botMessage: ChatMessage = {
        type: 'bot',
        content: data.message,
        timestamp: Date.now(),
        totalPrice: data.total_price,
        products: data.recommended_products
      };
    
      chatHistory.value.push(botMessage);
      response.value = data;
      
    // Save to localStorage
      localStorage.setItem('chatHistory', JSON.stringify(chatHistory.value));
      
      // Store recommended products in cart
      if (data.recommended_products?.length) {
        const buildItems = data.recommended_products.map((product: any) => ({
          product_id: product.product_id,
          product_name: product.product_name,
          product_category: product.category,
          product_price: product.sales_price,
          quantity: 1
        }));
        
        cartStore.saveBuildToLocal(buildItems);
        window.dispatchEvent(new Event('storage')); // Trigger storage event
      }
      
      message.value = '';
    } catch (error: any) {
      console.error('Chat error:', error);
      alert(error.response?.data?.detail || 'Failed to get recommendations');
    } finally {
      loading.value = false;
    }
  };

  // Load chat history when component mounts
  onMounted(() => {
    const savedHistory = localStorage.getItem('chatHistory');
    if (savedHistory) {
      chatHistory.value = JSON.parse(savedHistory);
    }
  });
</script>
  
<style scoped>
  .chat-box {
    position: fixed;
    bottom: 20px;
    right: 20px;
    z-index: 9999 !important; /* Increased z-index */
  }

  .chat-toggle {
    position: relative !important; /* Changed from absolute */
  width: 56px !important;
  height: 56px !important;
    border-radius: 50% !important;
  }
  
  .chat-window {
    width: 350px;
    height: 450px;
    display: flex;
    flex-direction: column;
  }
  
  .chat-header {
    background: #001655;
    color: white;
    padding: 12px 16px;
  }
  
  .chat-messages {
    flex-grow: 1;
    overflow-y: auto;
    padding: 16px;
    background: #f5f5f5;
  }
  
  .chat-input {
    padding: 12px;
    background: white;
  }
  
  .loading-indicator {
    display: flex;
    justify-content: center;
    padding: 20px;
  }
  
  .response-message {
    background: white;
    padding: 12px;
    border-radius: 8px;
    margin-bottom: 8px;
    color: black; /* Fallback color */
  }

  .message {
  margin-bottom: 12px;
  max-width: 85%;
}

.user-message {
  margin-left: auto;
  background-color: #e3f2fd;
  border-radius: 12px 12px 0 12px;
  padding: 8px 12px;
}

.bot-message {
  margin-right: auto;
  background-color: white;
  border-radius: 12px 12px 12px 0;
  padding: 8px 12px;
}

.message-content {
  word-wrap: break-word;
}

.chat-messages {
  display: flex;
  flex-direction: column;
  padding: 16px;
  background: #f5f5f5;
  overflow-y: auto;
  max-height: calc(450px - 120px); /* Adjust based on your chat window height */
}
</style>