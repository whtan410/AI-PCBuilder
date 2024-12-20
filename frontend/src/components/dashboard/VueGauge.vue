<template>
  <div class="gauge__outer mx-auto">
    <div class="gauge__inner">
      <div class="gauge__fill" :style="{ transform: `rotate(${cssTransformRotateValue})` }"></div>
      <div class="gauge__cover">
        <p v-if="indicator === 'rate'">
          {{ figure }}%
        </p>
        <p v-if="indicator === 'order'">
          RM{{ figure }}
        </p>
        <p v-if="indicator === 'score'">
          {{ figure }}⭐
        </p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.gauge__outer {
  width: 100%;
  max-width: 250px;
}

.gauge__inner {
  width: 100%;
  height: 0;
  padding-bottom: 50%;
  background: #b4c0be;
  position: relative;
  border-top-left-radius: 100% 200%;
  border-top-right-radius: 100% 200%;
  overflow: hidden;
}

.gauge__fill {
  position: absolute;
  top: 100%;
  left: 0;
  width: inherit;
  height: 100%;
  background: #bc2312;
  transform-origin: center top;
  transform: rotate(0turn);
  transition: transform 0.2s ease-out;
}

.gauge__cover {
  width: 75%;
  height: 150%;
  background: #000000;
  position: absolute;
  top: 25%;
  left: 50%;
  transform: translateX(-50%);
  border-radius: 50%;

  /* Text */
  display: flex;
  align-items: center;
  justify-content: center;
  padding-bottom: 25%;
  box-sizing: border-box;
  font-family: 'Lexend', sans-serif;
  font-weight: bold;
  font-size: 32px;
}
</style>

<script setup>
  import { computed,ref } from 'vue';
  let frac = ref("")

  const props = defineProps({
    indicator: {
      type: String,
      required: true
    },

    figure: {
      type: Number,
      required: true
    }
  })

  const cssTransformRotateValue = computed(() => {
    switch (props.indicator){
      case "rate":
        frac = props.figure / (100*2);
        break;
      case "order":
        frac = props.figure/ (10000*2);
        break;
      case "score":
        frac = props.figure/ (5*2);
        break;
    }

    return `${frac}turn`
  })

</script>

  