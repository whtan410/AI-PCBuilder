import { defineStore } from "pinia";
import useApi from "../composables/useApi";
import { useAuthStore } from "./auth"; // Import auth store

export type CartItem = {
    cart_item_id: number;
    type: 'product' | 'prebuilt';
    item_id: number; 
    product_name: string;
    category: string;
    quantity: number;
    price: number;
    total_price: number;
    img_url: string | null;
};

export type CartResponse = {
    user_id: string;
    items: CartItem[];
    total_items: number;
    cart_total: number;
};

interface CartItemCreate {
    product_id?: number | null;
    build_id?: number | null;
    quantity: number;
}

interface BuildItem {
    product_id: number;
    product_name: string;
    product_category: string;   
    product_price: number;
    quantity: number;
}

interface CartBulkItem {
    product_id: number;
    quantity: number;
}

export const useCartStore = defineStore("cart", {
    state: () => ({
        cartItems: [] as CartItem[],
        cartTotal: 0,
        totalItems: 0,
        buildItems: [] as BuildItem[],
        lastBuildItems: null as BuildItem[] | null,
    }),

    actions: {
        // fetch items from database
        async fetchCartItems() {
            const api = useApi();
            try {
                const response = await api.get<CartResponse>("/cart/");
                this.cartItems = response.data.items;
                this.cartTotal = response.data.cart_total;
                this.totalItems = response.data.total_items;
            } catch (error) {
                console.error('Error fetching cart items:', error);
                throw error; // Rethrow the error to be caught by the component
            }
        },

        async addPrebuiltToCart(item: CartItemCreate) {
            try {
                const api = useApi();
                const response = await api.post("/cart/", item);
                await this.fetchCartItems(); // Refresh cart after adding
                return response.data; // Return the response data
            } catch (error) {
                console.error('Error adding to cart:', error);
                throw error; // Rethrow the error to be caught by the component
            }
        },

        async updateCartItemQuantity(cartItemId: number, quantity: number) {
            const api = useApi();
            await api.put(`/cart/item/${cartItemId}/`, null, {
                params: { quantity }
            });
            await this.fetchCartItems(); // Refresh cart after update
        },

        async removeCartItem(cartItemId: number) {
            const api = useApi();
            await api.delete(`/cart/item/${cartItemId}/`);
            await this.fetchCartItems(); // Refresh cart after removal
        },

        async clearCart() {
            const api = useApi();
            await api.delete("/cart/");
            this.cartItems = [];
        },

        async saveBuildToCart(buildItems: BuildItem[]) {
            const authStore = useAuthStore();
            
            if (!authStore.isAuthenticated) {
                this.lastBuildItems = buildItems;
                throw new Error('Please login to save your build to cart');
            }
        
            try {
                const api = useApi();
                // Transform buildItems to match API format
                const cartItems: CartBulkItem[] = buildItems.map(item => ({
                    product_id: item.product_id,
                    quantity: item.quantity
                }));
        
                await api.post('/cart/bulk/', cartItems);
                await this.fetchCartItems();
            } catch (error) {
                console.error('Error saving build to cart:', error);
                throw error;
            }
        },

        saveBuildToLocal(items: BuildItem[]) {
            this.buildItems = items;
            localStorage.setItem('customBuildItems', JSON.stringify(items));
        },
      
        // Load build from localStorage
        loadBuildFromLocal() {
            const saved = localStorage.getItem('customBuildItems');
            if (saved) {
              this.buildItems = JSON.parse(saved);
              return this.buildItems;
            }
            return [];
        },
      
        // Update build item quantity
        updateBuildQuantity(buildItem: BuildItem) {
            const index = this.buildItems.findIndex(item => item.product_id === buildItem.product_id);
            
            if (buildItem.quantity <= 0) {
                // Remove item if quantity is 0
                if (index !== -1) {
                    this.buildItems.splice(index, 1);
                }
            } else if (index !== -1) {
                // Update existing item's quantity only
                this.buildItems[index].quantity = buildItem.quantity;
            } else {
                // Add new item with all properties
                this.buildItems.push({
                    product_id: buildItem.product_id,
                    product_name: buildItem.product_name,
                    product_category: buildItem.product_category,
                    product_price: buildItem.product_price,
                    quantity: buildItem.quantity
                });
            }
        
            this.saveBuildToLocal(this.buildItems);
        },

        clearBuildIData() {
            this.buildItems = [];
            this.lastBuildItems = null;
            localStorage.removeItem('customBuildItems');
        }

    }
});