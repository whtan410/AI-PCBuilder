import { defineStore } from "pinia";
import useApi from "../composables/useApi";

interface Profits{
    order_month: string;
    total_order_cost: number;
    total_sales_price: number;
}

interface Orders{
    average_order_value: number;
}

interface Conversions{
    conversion_rate: number;
}

interface Ratings{
    satisfaction_rating: number;
}

interface Brands{
    category: string;
    brand: string;
    count: number;
}

interface Stocks{
    product_name: string;
    stock_count: number;
}

interface Traffics{
    visit_date: Date;
    number_of_visits: number;
}

interface Sources{
    platform: string;
    platform_count: number;
}

// Add new interface
interface PrebuiltSales {
  build_name: string;
  total_sold: number;
}

export const useDashboardStore = defineStore("dashboardstore", {
    state : () => ({
        profits : [] as Profits [],
        orders : [] as Orders [],
        conversions : [] as Conversions[],
        ratings: [] as Ratings[],
        brands: [] as Brands[],
        stocks: [] as Stocks[],
        traffics: [] as Traffics[],
        sources: [] as Sources[],
        prebuiltSales: [] as PrebuiltSales[],
    }),

    actions: {
      // async fetchData<T>(endpoint: string): Promise<T[]> {
      fetchData: async function<T>(endpoint: string): Promise<T[]> {
        try {
            const api = useApi();
            const response = await api.get(endpoint);
            return response.data as T[];
        } catch (err) {
            console.log(err);
            throw err; // Optional: Rethrow the error if you want to handle it elsewhere
        } 
      },
      
      async fetchAllData(){
        try {
          await Promise.all([
            this.fetchProfits(),
            this.fetchOrders(),
            this.fetchConversions(),
            this.fetchRatings(),
            this.fetchBrands(),
            this.fetchStocks(),
            this.fetchTraffics(),
            this.fetchSources(),
            this.fetchPrebuiltSales()
          ])
        } catch(err){
          console.log(err)
        }
      },

      // Individual fetch functions (optional, if you want to fetch separately)
      async fetchProfits() {
        this.profits = await this.fetchData('/dashboard/profits/');
        // this.profits = await this.fetchData<Profits>('/dashboard/profits');
      },
      async fetchOrders() {
        this.orders = await this.fetchData('/dashboard/orders/');
        // this.orders = await this.fetchData<Orders>('/dashboard/orders');
      },
      async fetchConversions() {
        this.conversions = await this.fetchData('/dashboard/conversions/');
        // this.conversions = await this.fetchData<Conversions>('/dashboard/conversions');
      },
      async fetchRatings() {
        this.ratings = await this.fetchData('/dashboard/ratings/');
        // this.ratings = await this.fetchData<Ratings>('/dashboard/ratings');
      },
      async fetchBrands() {
        this.brands = await this.fetchData('/dashboard/brands/');
        // this.brands = await this.fetchData<Brands>('/dashboard/brands');
      },
      async fetchStocks() {
        this.stocks = await this.fetchData('/dashboard/stocks/');
        // this.stocks = await this.fetchData<Stocks>('/dashboard/stocks');
      },
      async fetchTraffics() {
        this.traffics = await this.fetchData('/dashboard/traffics/');
        // this.traffics = await this.fetchData<Traffics>('/dashboard/traffics');
      },
      async fetchSources() {
        this.sources = await this.fetchData('/dashboard/sources/');
        // this.sources = await this.fetchData<Sources>('/dashboard/sources');
      },
      async fetchPrebuiltSales() {
        this.prebuiltSales = await this.fetchData('/dashboard/prebuilt-sales/');
        // this.prebuiltSales = await this.fetchData<PrebuiltSales>('/dashboard/prebuilt-sales');
      },
    },
  });
