<template>
  <v-data-table
    :headers="headers"
    :items="items"
    class="elevation-1"  
    hover
    density="compact"
    :items-per-page="50"
  >


    <!-- Header styling -->
    <template #headers="{ columns }">
      <tr>
        <th
          v-for="column in columns"
          :key="column.key"
          class="table-cell"
          :class="column.align === 'end' ? 'text-end' : ''"
        >
          {{ column.title }}
        </th>
      </tr>
    </template>

    <!-- Row styling -->
    <template #item="{ item }"> 
      <tr class="table-cell">
        <td>{{ item.product_name }}</td>
        <td>{{ item.category }}</td>
        <td class="text-end">RM{{ item.price.toFixed(2) }}</td>
        <td class="text-end">x{{ item.quantity }}</td>
        <td class="text-end">RM{{ (item.price * item.quantity).toFixed(2) }}</td>
      </tr>
    </template>
    
    <!-- Bottom section styling -->
    <template v-slot:bottom>
      <div class="d-flex pa-4 table-cell">
        <div style="flex: 1;" class="text-h6"> Total: </div>
        <div style="flex: 1;"></div>
        <div class="text-h6 text-right ml-16">
          RM{{ calculateTotal(items).toFixed(2) }}
        </div>
      </div>
    </template>
  </v-data-table>
</template>

<script setup>
  import { defineProps } from 'vue'

  const headers = [
    { title: 'Product Name', key: 'product_name', align: 'start' },
    { title: 'Category', key: 'category', align: 'start' },
    { title: 'Unit Price', key: 'unit_price', align: 'end' },
    { title: 'Quantity', key: 'quantity', align: 'end' },
    { title: 'Total Price', key: 'total_price', align: 'end' },
  ]

  const props = defineProps({ items: { type: Array, required: true, default: () => [] } })

  const calculateTotal = (items) => {
    return items.reduce((sum, item) => sum + (item.price * item.quantity), 0)
  }

  const calculateTotalQuantity = (items) => {
    return items.reduce((sum, item) => sum + item.quantity, 0)
  }

</script>

<style scoped>
  .v-data-table {
    margin: 16px 0;
  }

  :deep(.table-cell) {
    background-color: #3e0054 !important;
    color: white !important;
  }

</style>