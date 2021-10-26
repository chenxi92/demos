<template>
  <button class="app-button" v-on="$attrs">
    <slot></slot>
  </button>
</template>

<script>
export default {
}
</script>

<style scoped>
.app-button {
  margin: 10px;
  padding: 10px 15px;
  border: none;
  border-radius: 5px;
  background-color: rgb(39, 224, 163);
  color: white;
  font-size: 20px;
}
</style>