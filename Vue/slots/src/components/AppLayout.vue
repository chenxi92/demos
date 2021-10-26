<template>
  <div class="layout">
    <header>
      <slot name="header"></slot>
    </header>
    <main>
      <slot></slot>
    </main>
    <footer>
      <slot name="footer">made with slots</slot>
    </footer>
  </div>
</template>

<style scoped>
header {
  width: 100%;
  height: 60px;
  position: fixed;
  top: 0;
  background-color: turquoise;
  color: white;
  font-size: 27px;
  font-weight: 700;
  text-align: center;
}
footer {
  width: 100%;
  height: 60px;
  position: fixed;
  bottom: 0;
  background-color: turquoise;
  color: white;
  font-size: 27px;
  font-weight: 700;
  text-align: center;
}
</style>