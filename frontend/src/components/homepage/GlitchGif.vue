<template>
    <div class="wrapper" :style="{ height: wrapperHeight }">
      <div class="content-container">
        <div class="glitch-wrapper bpdots" :style="{ opacity: opac + '%' }">
          <div class="glitch" :data-text="text">{{ text }}</div>
        </div>

        <v-btn
          v-if="showButton"
          class="custom-button bitstream"
          rounded="lg"
          to="/customise"
        >
          <span class="button-text">BUILD MY PC NOW</span>
        </v-btn>
      </div>
    </div>
</template>
  
<script setup>
    const props = defineProps({
        text: {
            type: String,
            required: true
        },
        showButton: {
            type: Boolean,
            default: false
        },
        opac: {
            type: Number,
            default: 100
        },
        wrapperHeight: {
            type: String,
            default: '100vh'
        }
    })
</script>
  
<style scoped>
  @import url('@/assets/BitStreamFont/stylesheet.css');
  @import url('@/assets/BPdotsFont/stylesheet.css');
  
  .wrapper {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 100%;
  }
  
  .content-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: clamp(15px, 2vh, 30px);
  }
  
  .glitch-wrapper {
    color: white;
    display: flex;
    justify-content: center;
    align-items: center;
    text-align: center;
    transform: scale(1);
    letter-spacing: clamp(4px, 1.5vw, 8px);
  }
  
  .glitch {
    font-size: clamp(3.5rem, 10vw, 8rem);
    font-weight: normal;
    text-transform: uppercase;
    position: relative;
    text-shadow: 0.05em 0 0 #00fffc, -0.03em -0.04em 0 #fc00ff,
                  0.025em 0.04em 0 #fffc00;
    animation: glitch 725ms infinite;
  }
  
  .custom-button {
    width: clamp(180px, 35vw, 300px) !important;
    height: clamp(35px, 5vh, 50px) !important;
    background-color: #E324BD !important;
    color: white !important;
    transition: all 0.3s ease;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    border-radius: 50px !important;
    margin-top: -10px;
  }
  
  .button-text {
    font-size: clamp(0.7rem, 1.5vw, 1.2rem);
    line-height: 1;
    white-space: nowrap;
    letter-spacing: 2px;
  }
  
  .custom-button:hover {
    transform: scale(1.05);
    background-color: #ff45d6 !important;
    box-shadow: 0 0 20px rgba(227, 36, 189, 0.7);
  }
  
  @keyframes glitch {
    0% {
      text-shadow: 0.05em 0 0 #00fffc, -0.03em -0.04em 0 #fc00ff,
                   0.025em 0.04em 0 #fffc00;
    }
    15% {
      text-shadow: 0.05em 0 0 #00fffc, -0.03em -0.04em 0 #fc00ff,
                   0.025em 0.04em 0 #fffc00;
    }
    16% {
      text-shadow: -0.05em -0.025em 0 #00fffc, 0.025em 0.035em 0 #fc00ff,
                   -0.05em -0.05em 0 #fffc00;
    }
    49% {
      text-shadow: -0.05em -0.025em 0 #00fffc, 0.025em 0.035em 0 #fc00ff,
                   -0.05em -0.05em 0 #fffc00;
    }
    50% {
      text-shadow: 0.05em 0.035em 0 #00fffc, 0.03em 0 0 #fc00ff,
                   0 -0.04em 0 #fffc00;
    }
    99% {
      text-shadow: 0.05em 0.035em 0 #00fffc, 0.03em 0 0 #fc00ff,
                   0 -0.04em 0 #fffc00;
    }
    100% {
      text-shadow: -0.05em 0 0 #00fffc, -0.025em -0.04em 0 #fc00ff,
                   -0.04em -0.025em 0 #fffc00;
    }
  }
  
  /* Responsive styles */
  @media (max-width: 960px) {
    .glitch {
      font-size: clamp(3rem, 9vw, 7rem);
    }
    
    .custom-button {
      width: clamp(160px, 32vw, 280px) !important;
      height: clamp(32px, 4.5vh, 45px) !important;
    }
  }
  
  @media (max-width: 600px) {
    .glitch {
      font-size: clamp(2.5rem, 8vw, 6rem);
    }
    
    .custom-button {
      width: clamp(150px, 30vw, 260px) !important;
      height: clamp(30px, 4vh, 40px) !important;
    }
  
    .button-text {
      font-size: clamp(0.6rem, 1.2vw, 1rem);
    }
  
    .glitch-wrapper {
      letter-spacing: 4px;
      margin-bottom: -5px;
    }
  }
  
  @keyframes glitch-anim {
    0% {
      clip: rect(16px, 9999px, 95px, 0);
    }
    20% {
      clip: rect(120px, 9999px, 166px, 0);
    }
    40% {
      clip: rect(79px, 9999px, 76px, 0);
    }
    60% {
      clip: rect(23px, 9999px, 107px, 0);
    }
    80% {
      clip: rect(132px, 9999px, 162px, 0);
    }
    100% {
      clip: rect(147px, 9999px, 179px, 0);
    }
  }
  
  @keyframes glitch-anim2 {
    0% {
      clip: rect(129px, 9999px, 36px, 0);
    }
    20% {
      clip: rect(13px, 9999px, 177px, 0);
    }
    40% {
      clip: rect(145px, 9999px, 34px, 0);
    }
    60% {
      clip: rect(121px, 9999px, 162px, 0);
    }
    80% {
      clip: rect(12px, 9999px, 178px, 0);
    }
    100% {
      clip: rect(13px, 9999px, 194px, 0);
    }
  }
  </style>