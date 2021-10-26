<template>
  <!-- <AppLayout>
    <template #header>
      Slots are awesome
    </template>
    <AppButton @click="log">
      press me
    </AppButton>
  </AppLayout> -->
  <AppUserList>
    <template #secondrow="{remove, item: user}">
      <!-- <a :href="'tel:' + slotProps.item.phone">
        {{ slotProps.item.phone}}
      </a>  -->
      <AppButton @click="remove(user)">{{ user.name.first }}</AppButton>
    </template>
  </AppUserList>
</template>

<script>
import AppButton from './components/AppButton.vue'
// import Icon from './components/Icon.vue'
// import AppLayout from '@/components/AppLayout'
import AppUserList from '@/components/AppUserList'

export default {
  name: 'App',
  components: {
    AppButton,
    // AppLayout
    // Icon
    AppUserList
  },
  methods: {
    log() {
      console.log('clicked');
    }
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
