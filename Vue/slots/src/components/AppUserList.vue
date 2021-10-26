<template>
  <section>
    <slot name="title">Users</slot>
    <ul class="userlist" v-if="state === 'loaded'">
      <li v-for="item in data.results" :key="item.email">
        <div class="list-item">
          <img width="48" height="48" :src="item.picture.large" :alt="item.name.first + ' ' + item.name.last" />
          <div class="text">
            <div> {{ item.name.first }}</div>
            <slot name="secondrow" :item="item" :remove="remove"></slot>
          </div>
        </div>
      </li>
    </ul>
    <slot v-if="state === 'loading'" name="loading">
      loading...
    </slot>
    <slot v-if="state === 'failed'" name="error">
      Oops, something went wrong.
    </slot>
  </section>
</template>

<script>
const states = {
  idle: "idle",
  loading: "loading",
  loaded: "loaded",
  failed: "failed"
}
export default {
  data() {
    return {
      state: 'idle',
      error: undefined,
      data: undefined,
      states
    }
  },
  mounted() {
    this.load();
  },
  methods: {
    async load() {
      this.state = "loading";
      this.error = undefined;
      this.data = undefined;
      try {
        setTimeout(async() => {
          const response = await fetch("https://randomuser.me/api/?results=5");
          const json = await response.json();
          console.log("data = ", json);
          this.state = "loaded";
          this.data = json;
          return response;
        }, 1000);
      } catch(error) {
        this.state = "failed"
        this.error = error;
        console.log("--- error: ", error);
        return error;
      }
    },
    remove(item) {
      this.data.results = this.data.results.filter((entry) => {
        return entry.email !== item.email;
      });
    }
  }
}
</script>

<style scoped>
.userlist li {
  height: auto;
  display: inline;
}
.list-item {
  display: inline;
  display: flex;
  justify-content: flex-start;
  margin: 10px 0;
}
.text {
  font-weight: bold;
  font-size: 19px;
  display: block;
  margin-left: 20px;
  text-align: left;
}
</style>