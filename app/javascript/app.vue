<template>
  <div class="container text-center mt-5">
    <div class="row">
      <div class="col-md-12">
        <div id="app">
          <p>{{ message }}</p>

          <Orders/>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
// Importo el componente 'Orders' 
import Orders from './Orders.vue'

export default {
  components: {
      Orders,
  },
  data: function () {
    return {
      message: "Pizza Orders"
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
