<template>
  <div id="app">
    <router-view/>
  </div>
</template>

<style>
@import "~bootstrap/dist/css/bootstrap.css";
.txt-color{
  color: rgba(117,117,117,1);
}

@media only screen and (max-width: 768px) {
  .blk.col-12.col-lg-8 {
      border: none !important;
  }
}
</style>

