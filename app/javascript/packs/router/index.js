
import orders from '../components/orders.vue'
import ordernew from '../components/ordernew'
import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)
export default new Router({
  mode: 'history',
  routes: [ 
    { path: '/',
    name: 'ordes',
    component: orders
    },
    { path: '/ordernew',
      name: 'ordernew',
      component: ordernew,
    }
  ]
}) 

