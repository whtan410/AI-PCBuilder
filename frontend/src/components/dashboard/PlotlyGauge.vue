<!-- GaugeChart.vue -->
<template>
  <div ref="gaugeElement"></div>
</template>

<script setup>
  import { onMounted, watch, ref } from 'vue'
  import Plotly from 'plotly.js-dist'

  // Define props using the `defineProps` API
  const props = defineProps({
    chartData: Array,
    chartLayout: Object,
    config: Object
  })

  const gaugeElement = ref(null)

  const renderChart = () => {
  if (
    gaugeElement.value &&
    props.chartData.length &&
    Object.keys(props.chartLayout).length &&
    Object.keys(props.config).length
  ) {
    Plotly.newPlot(gaugeElement.value, props.chartData, props.chartLayout, props.config)
  }
}
  onMounted(() => {
    renderChart();
  });

  watch(
    () => [props.chartData,props.chartLayout,props.config],
    () => {
      renderChart();
    },
    { deep: true }
  );

</script>
