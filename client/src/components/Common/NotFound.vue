<template>
    <div id="app"></div>
</template>

<script>
    export default {
        name: "NotFound",
        created() {
            this.$router.push('/');
        },
    }
</script>