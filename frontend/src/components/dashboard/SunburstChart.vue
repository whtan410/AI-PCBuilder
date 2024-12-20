<template>
  <div class="sbc-container">
    <div ref="plotElement"></div>
  </div>
</template>
   
<script setup>
  import { ref, watch, onMounted } from 'vue';
  import Plotly from 'plotly.js-dist';

  const props = defineProps({
    chartData: {
      type: Array,
      required: true,
    },
    chartLayout: {
      type: Object,
      required: true,
    },
    config: {
      type: Object,
      required: true,
    },
  });

  const plotElement = ref(null);

  const renderChart = () => {
    if (plotElement.value && props.chartData.length && Object.keys(props.chartLayout).length && Object.keys(props.config).length) {
      Plotly.newPlot(plotElement.value, props.chartData, props.chartLayout, props.config);
    }
  };

  onMounted(() => {
    renderChart();
  });

  watch(
    () => [props.chartData, props.chartLayout, props.config],
    () => {
      renderChart();
    },
    { deep: true }
  );
  </script>

