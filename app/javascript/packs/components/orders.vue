<template>
  <v-data-table :headers="headers" :items="orders" sort-by="Order_ID" class="elevation-1">
    <template v-slot:top>
      <v-toolbar flat color="white">
        <v-toolbar-title>Orders</v-toolbar-title>
        <v-divider class="mx-4" inset vertical></v-divider>
        <v-spacer></v-spacer>

        <v-dialog v-model="dialog" max-width="500px">
          <template v-slot:activator="{ on }">
            <v-btn color="primary" dark class="mb-2" v-on="on">New Order</v-btn>
          </template>
          <v-card>
            <v-card-title>
              <span class="headline">{{ formTitle }}</span>
            </v-card-title>
            <v-card-text>
              <v-container>
                <v-row>
                  <v-col cols="12" sm="6" md="4">
                    <v-text-field v-model="editedItem.Order_ID" label="Order_ID"></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="6" md="4">
                    <v-select v-model="editedItem.Crust" :items="crust_type" label="Crust"></v-select>
                  </v-col>
                  <v-col cols="12" sm="6" md="4">
                    <v-select v-model="editedItem.Flavor" :items="flavor" label="Flavor"></v-select>
                  </v-col>
                  <v-col cols="12" sm="6" md="4">
                    <v-select v-model="editedItem.Size" :items="size" label="Size"></v-select>
                  </v-col>
                  <v-col cols="12" sm="6" md="4">
                    <v-text-field v-model="editedItem.Table_No" label="Table No"></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="6" md="4">
                    <v-menu ref="menu" v-model="editedItem.Timestamp" :close-on-content-click="false" :return-value.sync="date" transition="scale-transition" offset-y min-width="auto">
                      <template v-slot:activator="{ on, attrs }">
                        <v-text-field v-model="date" label="Timestamp" prepend-icon="mdi-calendar" readonly v-bind="attrs" v-on="on"></v-text-field>
                      </template>
                      <v-date-picker v-model="date" no-title scrollable>
                        <v-spacer></v-spacer>
                        <v-btn text color="primary" @click="menu = false" >Cancel</v-btn>
                        <v-btn text color="primary" @click="$refs.menu.save(date)">OK</v-btn>
                      </v-date-picker>
                    </v-menu>
                  </v-col>
                </v-row>
              </v-container>
            </v-card-text>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="close">Cancel</v-btn>
              <v-btn color="blue darken-1" text @click="save(editedItem)">Save</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-toolbar>
    </template>

    <template v-slot:item.action="{ item }">
      <v-icon small class="mr-2" @click="editItem(item)">edit</v-icon>
      <v-icon small @click="deleteItem(item)">delete</v-icon>
    </template>

    <template v-slot:no-data>
      <v-btn color="primary" @click="initialize">Reset</v-btn>
    </template>

  </v-data-table>
</template>

<script>
import axios from "axios";
export default {
  name: 'orders',

  data: () => ({
    dialog: false,
    crust_type: ['THIN','Fast Food Pizza', 'Cheese-Stuffed Crust', 'Pizza Bagels', 'Flatbread', 'Thin Crust', 'Sicilian Style', 'Chicago Deep Dish', 'Neapolitan Crust', 'NY Style Pizza'],
    size: ['L','M','S'],
    flavor: ['spicy','Pepperoni Pizza','Meat Pizza', 'Margherita Pizza', 'BBQ Chicken Pizza', 'Hawaiian Pizza', 'Buffalo Pizza'],
    date: (new Date(Date.now() - (new Date()).getTimezoneOffset() * 60000)).toISOString().substr(0, 10),
      menu: false,
    headers: [
      {
        text: "Order ID",
        align: "left",
        sortable: false,
        value: "Order_ID"
      },
      { text: "Crust", value: "Crust" },
      { text: "Flavor", value: "Flavor" },
      { text: "Size", value: "Size" },
      { text: "Table No", value: "Table_No" },
      { text: "Timestamp", value: "created_at", sortable: false },
      { text: "Actions", value: "action", sortable: false }
    ],
    orders: [],
    editedIndex: -1,
    editedItem: {
      Order_ID: "",
      Crust: "",
      Flavor: "",
      Size: "",
      Table_No: "",
      Timestamp: ""
    },
    defaultItem: {
      Order_ID: "",
      Crust: "",
      Flavor: "",
      Size: "",
      Table_No: "",
      Timestamp: ""
    }
  }),
  computed: {
    formTitle() {
      return this.editedIndex === -1 ? "New Order" : "Edit Order";
    }
  },
  watch: {
    dialog(val) {
      val || this.close();
    }
  },

  created() {
    this.initialize();
  },
  methods: {
    initialize() {
      return axios
        //.get("http://localhost:3000/orders")
        .get("https://order-pizza-api.herokuapp.com/api/orders")
        .then(response => {
          console.log(response.data);
          this.orders = response.data;
        })
        .catch(e => {
          console.log(e);
        });
    },
    editItem(item) {
      this.editedIndex = item.id;
      this.editedItem = Object.assign({}, item);
      this.dialog = true;
    },

    deleteItem(item) {
      const index = this.orders.indexOf(item);
      confirm("Are you sure you want to delete this item?");
      axios
        //.delete(`http://localhost:3000/order/${item.id}`)
        .delete(`https://order-pizza-api.herokuapp.com/api/orders/${item.id}`)
        .then(response => {
          console.log(response);
          console.log(response.data.json);
          alert(response.data.json);
          this.initialize();
        })
        .catch(error => {
          console.log(error);
        });
      this.orders.splice(index, 1);
    },

    close() {
      this.dialog = false;
      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      }, 300);
    },

    save(item) {
      if (this.editedIndex > -1) {
        axios
          //.put(`http://localhost:3000/order/${item.id}`, {
          .put(`https://order-pizza-api.herokuapp.com/api/orders/${item.id}`, {
            id: this.editedItem.id,
            first_name: this.editedItem.first_name,
            last_name: this.editedItem.last_name,
            email: this.editedItem.email,
            phone: this.editedItem.phone,
            address: this.editedItem.address
          })
          .then(response => {
            console.log(response);
            this.initialize();
          })
          .catch(error => {
            console.log(error);
          });
      } else {
        console.log(item);
        axios
          //.post(`http://localhost:3000/orders`, {
          .post(`https://order-pizza-api.herokuapp.com/api/orders`, {
            user: this.editedItem
          })
          .then(response => {
            console.log(response);
            console.log("Created!");
            this.initialize();
          })
          .catch(error => {
            console.log(error);
          });
        this.orders.push(this.editedItem);
      }
      this.close();
    },

    getOrder(item) {
      axios
        //.get(`http://localhost:3000/order/${item.id}`)
        .get(`https://order-pizza-api.herokuapp.com/api/orders/${item.id}`)
        .then(response => {
          this.order = response.data;
        })
        .catch(error => {
          console.log(error);
        });
    }
  
  }
  

}
</script>

<style>

</style>