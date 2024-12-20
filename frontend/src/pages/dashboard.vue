<template>
    <h1 class="text-center my-5"> Business Dashboard </h1>
    <div class="mb-0">
      <h2 class='text-center mb-5'> Sales Management </h2>
        <v-row>
            <v-col cols="11" class="mx-auto mb-10">
                <v-card border="opacity-50 lg" class="pa-5">
                    <LineChart :chartData="doublelinechartData" :chartOptions="doublelinechartOptions"/>
                </v-card>
            </v-col>
        </v-row>

        <v-row class="d-flex justify-space-around">
            <v-col cols="3">
                <h2 class="text-center mb-5"> Average Order Value </h2>

                <v-card border="opacity-50 lg">
                    <PlotlyGauge :chartData="ordergaugeData" :chartLayout="plotgaugeLayout" :config="plotgaugeConfig"/>
                </v-card>
            </v-col>

            <v-col cols="3">
                <h2 class="text-center mb-5"> Order Conversion Rate </h2>

                <v-card border="opacity-50 lg">
                    <PlotlyGauge :chartData="conversiongaugeData" :chartLayout="plotgaugeLayout" :config="plotgaugeConfig"/>
                </v-card>
            </v-col>

            <v-col cols="3">
                <h2 class="text-center mb-5"> Customer Satisfaction Rating </h2>

                <v-card border="opacity-50 lg">
                    <PlotlyGauge :chartData="csrgaugeData" :chartLayout="plotgaugeLayout" :config="plotgaugeConfig"/>
                </v-card>
            </v-col>
        </v-row>

        <v-row class="mt-15 d-flex justify-space-around mt-0 ">
            <v-col cols="11" class="mb-10">
                <h2 class="text-center mb-5"> PC Components Sales Number By Parts and Brands </h2>
                <v-card border="opacity-50 lg mb-5">
                    <SunburstChart :chartData="sunburstStore.chartData" :chartLayout="sunburstStore.chartLayout" :config="sunburstStore.chartConfig" />
                </v-card>
            </v-col>
        </v-row>
    </div>

    <div class="mt-0">
        <v-row class="d-flex justify-space-around">
            <v-col lg="5" xs="12" class="my-auto">
                <h2 class="text-center section-title mb-5"> Inventory management</h2>
                <v-card border="opacity-50 lg" class="chart-card mb-5">
                    <BarChart :chartData="barchartData" :chartOptions="barchartOptions"/>
                </v-card>
            </v-col>

            <v-col lg="5" xs="12" class="my-auto" >
                <h2 class="text-center mb-5"> Prebuilt PC sales</h2>
                <v-card border="opacity-50 lg" class="chart-card" >
                    <BarChart :chartData="prebuiltBarchartData" :chartOptions="prebuiltBarchartOptions"/>
                </v-card>
            </v-col>
        </v-row>

        <v-row class="d-flex justify-space-around">
            <v-col lg="7" xs="12" class="my-auto">
                <h2 class="text-center mb-5"> Traffic engagement</h2>
                <v-card border="opacity-50 lg" class="chart-card mb-5">
                    <LineChart :chartData="singlelinechartData" :chartOptions="singlelinechartOptions"/>
                </v-card>
            </v-col>

            <v-col lg="3" xs="12" class="my-auto" >
                <h2 class="text-center mb-5"> Traffic Source</h2>
                <v-card border="opacity-50 lg" class="chart-card pt-15" >
                    <PieChart :chartData="piechartData" :chartOptions="piechartOptions"/>
                </v-card>
            </v-col>
        </v-row>
    </div>
</template>
  
<script setup>
    import { ref, onMounted } from 'vue';
    import { storeToRefs } from 'pinia'

    import LineChart from '@/components/dashboard/LineChart'
    import PieChart from '@/components/dashboard/PieChart'
    import VueGauge from '@/components/dashboard/VueGauge'    
    import SunburstChart from '@/components/dashboard/SunburstChart'
    import PlotlyGauge from '@/components/dashboard/PlotlyGauge.vue'
    import BarChart from '@/components/dashboard/BarChart.vue'

    import { useSunburstStore } from '@/stores/sunburstchartstore';
    import { useDashboardStore } from '../stores/dashboardstore'; 

    const dashboardStore = useDashboardStore();
    const { profits, orders, conversions, ratings, brands, stocks, traffics,prebuiltSales, sources } = storeToRefs(dashboardStore);

    const sunburstStore = useSunburstStore();
    const { labels, parents, values } = storeToRefs(sunburstStore);

    onMounted(async () => {
        await dashboardStore.fetchAllData();
        await sunburstStore.loadSunburstData();
    });

    //sales management line chart - data
    const doublelinechartData = computed(() => ({
        labels: profits.value.map(item => item.order_month),
        datasets: [
            { 
                label: "Revenue",
                backgroundColor: '#8479f8',
                borderColor: '#8479f8',
                data: profits.value.map(item => item.total_sales_price)
            },
            { 
                label: "Cost",
                backgroundColor: '#f87979',
                borderColor: '#f87979',
                data: profits.value.map(item => item.total_order_cost)
            },
        ]}))
    
    //sales management line chart - style
    const doublelinechartOptions = ref({
        responsive: true,
        maintainAspectRatio: false,
        aspectRatio: 0.8,
        scales: {
            x: {
                display: true,
                title: {
                    display: true,
                    text: 'Months',
                    color: 'white',
                },
                ticks: { color: 'white' },
            },
            y: {
                display: true,
                title: {
                    display: true,
                    text: 'Dollar ($)',
                    color: 'white',
                },
                ticks: { color: 'white' },
            },
        },
        plugins: {
            title: {
                display: true,
                text: 'Revenue versus Cost over past 12 months',
                color: 'white',
                font: { size: 18 },
            },
            legend: {
                position: 'top',
                labels: { color: 'white' },
            },
        },
    });

    //average order value gauge-data
    const ordergaugeData = computed(() => ([
        {
            domain: { x: [0, 1], y: [0, 1] },
            value: orders.value.average_order_value,
            type: "indicator",
            mode: "gauge+number",
            number: { prefix: "$" },
            gauge: {
                bar: { thickness: 0.8 },
                axis: { 
                    range: [0, 50000],
                    tickvals: [10000, 20000, 30000, 40000, 50000],  // Set specific tick values
                    ticktext: ["$10k", "$20k", "$30k", "$40k", "$50k"]   // Set custom labels for each tick value
                },
                threshold: {
                    line: { color: "red", width: 4 },
                    thickness: 0.75,
                    value: 49000
                }
            }
        }
    ]))

    //average order value gauge-data
    const conversiongaugeData = computed(() => ([
        {
            domain: { x: [0, 1], y: [0, 1] },
            value: conversions.value.conversion_rate,
            type: "indicator",
            mode: "gauge+number",
            number: { suffix: "%" },
            gauge: {
                bar: { thickness: 0.8 },
                axis: { 
                    range: [0, 20],
                    tickvals: [5, 10, 15, 20],  // Set specific tick values
                    ticktext: ["5%", "10%", "15%", "20%"]   // Set custom labels for each tick value
                },
                threshold: {
                    line: { color: "red", width: 4 },
                    thickness: 0.75,
                    value: 19
                }
            }
        }
    ]))

    const csrgaugeData = computed(() => ([
        {
            domain: { x: [0, 1], y: [0, 1] },
            value: ratings.value.satisfaction_rating,
            type: "indicator",
            mode: "gauge+number",
            number: { prefix: "⭐" },
            gauge: {
                bar: { thickness: 0.8 },
                axis: { 
                    range: [0, 5],
                    tickvals: [1, 2, 3, 4 , 5],  // Set specific tick values
                    ticktext: ["1", "2", "3", "4","5"]   // Set custom labels for each tick value
                },
                threshold: {
                    line: { color: "red", width: 4 },
                    thickness: 0.75,
                    value: 4.9
                }
            }
        }
    ]))

    //all plot layout
    const plotgaugeLayout = {
        height: 400,
        margin: { t: 0, b: 0, pad: 0 },
        paper_bgcolor: 'black',
        font: {
            color: "white"
        }
    }

    //all plot config
    const plotgaugeConfig = {
        responsive: true,
        displayModeBar: false,
        autosizable: true
    }

    //inventory management bar chart - data 
    const barchartData = computed(() => ({
        labels: stocks.value.map((item) => item.product_name),
        datasets: [
            { 
            label: 'PC Components',
            backgroundColor: '#f87979',
            data: stocks.value.map((item)=> item.stock_count)
            }
        ]
        })
    );

    //inventory management bar chart - style
    const barchartOptions = ref({
        responsive: true,
        maintainAspectRatio: false,
        aspectRatio: 1,
        scales: {
            x: {
            display: true,
            title: {
                display: true,
                text: 'PC Components',
                color: "white"
            },
            ticks: { color: 'white' }
            },
            y: {
            display: true,
            title: {
                display: true,
                text: 'Stock Count',
                color: "white"
            },
            ticks: { color: 'white' }
            }
        },
        layout: {
            padding: {
            left: 10,
            right: 10,
            top: 10,
            bottom: 10
            }
        },
        plugins: {
            title: {
            display: true,
            text: 'Top 10 Item Less in Stock',
            color: "white"
            },
            legend: {
            labels: { color: 'white' }
            }
        }
    });

    const prebuiltBarchartData = computed(() => ({
        labels: prebuiltSales.value.map((item) => item.build_name),
        datasets: [
            { 
                label: 'Units Sold',
                backgroundColor: '#8479f8',
                data: prebuiltSales.value.map((item) => item.total_sold),
                barPercentage: 0.3,  // Make bars thinner
                categoryPercentage: 1.0  // Add more space between bars
            }
        ]
    }));

    const prebuiltBarchartOptions = ref({
        responsive: true,
        maintainAspectRatio: false,
        aspectRatio: 1,
        scales: {
            y: {  // This becomes the horizontal axis (categories)
                display: true,
                title: {
                    display: true,
                    text: 'Prebuilt PC Models',
                    color: "white"
                },
                ticks: { 
                    color: 'white',
                    maxRotation: 0
                }
            },
            x: {  // This becomes the vertical axis (values)
                display: true,
                title: {
                    display: true,
                    text: 'Units Sold',
                    color: "white"
                },
                ticks: { 
                    color: 'white',
                    beginAtZero: true
                }
            }
        },
        layout: {
            padding: {
                left: 10,
                right: 30,  // Added more padding for labels
                top: 10,
                bottom: 10
            }
        },
        plugins: {
            title: {
                display: true,
                text: 'Prebuilt PC Sales Performance',
                color: "white"
            },
            legend: {
                labels: { color: 'white' }
            }
        }
    });

    //traffic engagement line chart - data
    const singlelinechartData = computed(() => ({
        labels: traffics.value.map((item) => item.visit_date),
        datasets: [
            {
                label: "Visits",
                backgroundColor: '#8479f8',
                borderColor: '#8479f8',
                data: traffics.value.map((item) => item.number_of_visits),
            }
        ]
    }));

    //traffic engagement line chart - style
    const singlelinechartOptions = ref({
        responsive: true,
        maintainAspectRatio: false,
        aspectRatio: 1,
        layout: {
            padding: {
            left: 30,
            right: 30,
            top: 10,
            bottom: 10
            }
        },
        scales: {
            x: {
                display: true,
                title: {
                    display: true,
                    text: 'Day',
                    color: "white"
            },
            ticks: { color: 'white' }
            },
            y: {
                type: 'linear',
                display: true,
                title: {
                    display: true,
                    text: 'Number of visits',
                    color: "white"
            },
            ticks: { color: "white" }
            }
        },
        plugins: {
            title: {
                display: true,
                text: 'Website daily visits',
                color: 'white'
            },
            legend: {
                labels: { color: 'white' }
            }
        }
    });

    //traffic source pie chart - data
    const piechartData = computed(() => ({
        labels: sources.value.map((item) => item.platform),
        datasets: [{
            backgroundColor: ['#41B883', '#E46651', '#00D8FF', '#DD1B16', '#d1bee0'],
            borderColor: 'black',
            data: sources.value.map((item) => item.platform_count)
        }]
    }));

    //traffic source pie chart - style
    const piechartOptions = ref({
        responsive: true,
        maintainAspectRatio: false,
        aspectRatio: 400,
        layout: {
            padding: {
            left: 30,
            right: 30,
            top: 10,
            bottom:120
            }
        },
        plugins: {
            title: {
                display: false,
                text: 'Traffic source',
                color: 'white'
            },
                legend: {
                position: 'left',
                labels: { color: 'white' }
            }
        }
    });

    
</script>

<style scoped>
    .chart-card {
    height: 300px; /* Fixed height for consistent chart size */
    min-height: 300px;
    width: 100%
    }
</style>

<route lang="yaml">
    meta:
      requiresMaster: true
</route>