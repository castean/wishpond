<template>
  <div class="table-responsive">  
    <table class="table mt-3" :items="data" :fields="fields">
      <thead class="thead-dark">
        <tr>
          <th scope="col">Order ID</th>
          <th scope="col">Crust</th>
          <th scope="col">Flavor</th>
          <th scope="col">Size</th>
          <th scope="col">Table No</th>
          <th scope="col">Time Stamp</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="order in data" v-bind:key="order.order_ID">   
          <td>{{ order.Order_ID }}</td>       
          <td>{{ order.Crust }}</td>
          <td>{{ order.Flavor }}</td>
          <td>{{ order.Size }}</td>
          <td>{{ order.Table_No }}</td>
          <td>{{ order.Timestamp }}</td>
          
        </tr>
      </tbody>
    </table> 
  </div>
</template>

<script>
export default {
  name: 'Orders',
 
  data: function () {
    return {
      // Campos 
      fields: ['Crust', 'Flavor', 'Order_ID', 'Size', 'Table_No', 'Timestamp'],

      // Obtenemos los datos en el array 'data' 
      data: []
    }
  },

  // Leemos los datos JSON con axios 
  mounted() {
    axios
      //.get('https://unirsails.herokuapp.com/tickets')
      .get("https://order-pizza-api.herokuapp.com/api/orders")
      .then(response => {
          this.data = response.data;
          console.log(this.data); 
      });
  },
}
</script>

<style>

</style>