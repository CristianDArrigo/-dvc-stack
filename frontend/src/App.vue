<script setup></script>

<template>
  <div id="app">
    <HelloDjango />
  </div>
</template>

<style scoped></style>

<script>
import HelloDjango from './components/HelloDjango.vue'
export default {
  name: 'App',
  components: {
    HelloDjango
  }
}
</script>