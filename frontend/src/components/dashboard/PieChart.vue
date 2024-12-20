<template>
    <div>
        <Pie :data="chartData" :options="chartOptions" />
    </div>
</template>

<script setup>
    import { defineProps } from 'vue';
    import { Pie } from 'vue-chartjs'
    import { Chart as ChartJS, ArcElement, Tooltip, Legend } from 'chart.js'
    ChartJS.register(ArcElement, Tooltip, Legend)

    const props = defineProps({
        chartData: {
            type: Object,
            required: true,
        },
        chartOptions: {
            type: Object,
            required: true,
        },
    });
</script>