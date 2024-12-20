import { defineStore } from "pinia";
import useApi from "../composables/useApi";

export interface Product {
  product_id: number;      
  product_name: string;    
  product_category: string;
  product_price: number;   
  product_stock: number;   
  product_image: string;   
}

export interface ComponentResponse {
  title: string;
  image: string;
  description: string;
  product_list: Product[];
}

export const useProductStore = defineStore("product", {
  state: () => ({
    components: [] as ComponentResponse[],
    stockQuantities: {} as Record<string, number>,
    loading: false,
    error: null,
  }),

  getters: {
    getComponentsByCategory: (state) => (category: string) => {
      return state.components.filter(component => component.title.toLowerCase() === category.toLowerCase());
    },

    getRemainingStock: (state) => (productId: number) => {
      // Find product and return remaining stock after subtracting reserved quantity
      const product = state.components
        .flatMap(comp => comp.product_list)
        .find(p => p.product_id === productId);
      
      const reserved = state.stockQuantities[productId] || 0;
      return product ? product.product_stock - reserved : 0;
    }
  },

  actions: {
    async fetchAllComponents() {
      try {
        const api = useApi();
        const response = await api.get<ComponentResponse[]>("/products/");
        this.components = response.data as ComponentResponse[];
      } catch (error) {
        console.error('Error fetching components:', error);
        throw error; // Rethrow the error to be caught by the component
      }
    },

    updateStockQuantities(productId: number, quantity: number) {
      this.stockQuantities[productId] = quantity;
    },

    resetStockQuantities() {
      this.stockQuantities = {};
    }
  }
});
