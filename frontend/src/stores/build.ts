import { defineStore } from "pinia";
import useApi from "../composables/useApi";

interface PrebuiltPCResponse {
    build_id: number;
    build_name: string;
    build_parts: Record<string, any>;
    build_price: number;
    build_img_url: string | null;
}

export const useBuildStore = defineStore("buildstore", {
    state: () => ({
        prebuiltPC : [] as PrebuiltPCResponse[],
    }),

    actions: {
        async fetchPrebuiltPCs() {
            const api = useApi();
            const response = await api.get("/shop/prebuilt");
            this.prebuiltPC  = response.data as PrebuiltPCResponse[];
        },
    },
});

