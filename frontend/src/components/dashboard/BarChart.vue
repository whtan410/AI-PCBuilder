<template>
  <div>
    <Bar :data="chartData" :options="chartOptions"/>
  </div>
</template>
  
<script setup>
  import { defineProps } from 'vue';
  import { Bar } from 'vue-chartjs'
  import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js'

  ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)
    
  const props = defineProps({
    chartData: {
      type: Object,
      required: true,
    },

    chartOptions: {
      type: Object,
      required: true,
    }
  })
</script>