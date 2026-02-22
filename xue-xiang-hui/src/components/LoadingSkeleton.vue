<template>
  <div class="loading-skeleton">
    <!-- 网格骨架屏 -->
    <template v-if="type === 'grid'">
      <el-row :gutter="20">
        <el-col
          v-for="i in rows"
          :key="i"
          :xs="24"
          :sm="12"
          :md="8"
          :lg="6"
        >
          <el-card class="skeleton-card" shadow="hover">
            <el-skeleton animated>
              <template #template>
                <el-skeleton-item variant="image" style="width: 100%; height: 120px;" />
                <div style="padding: 14px;">
                  <el-skeleton-item variant="h3" style="width: 80%;" />
                  <el-skeleton-item variant="text" style="margin-top: 10px;" />
                  <el-skeleton-item variant="text" style="width: 60%; margin-top: 10px;" />
                </div>
              </template>
            </el-skeleton>
          </el-card>
        </el-col>
      </el-row>
    </template>

    <!-- 列表骨架屏 -->
    <template v-else-if="type === 'list'">
      <el-card class="skeleton-list" v-for="i in rows" :key="i" shadow="hover">
        <el-skeleton animated>
          <template #template>
            <div style="display: flex; align-items: center; gap: 20px;">
              <el-skeleton-item variant="circle" style="width: 50px; height: 50px;" />
              <div style="flex: 1;">
                <el-skeleton-item variant="h3" style="width: 40%;" />
                <el-skeleton-item variant="text" style="margin-top: 10px; width: 70%;" />
              </div>
              <el-skeleton-item variant="button" style="width: 80px; height: 32px;" />
            </div>
          </template>
        </el-skeleton>
      </el-card>
    </template>

    <!-- 详情骨架屏 -->
    <template v-else-if="type === 'detail'">
      <el-card>
        <el-skeleton animated>
          <template #template>
            <el-skeleton-item variant="h1" style="width: 60%; margin-bottom: 20px;" />
            <div style="display: flex; gap: 20px; margin-bottom: 30px;">
              <el-skeleton-item variant="image" style="width: 300px; height: 200px;" />
              <div style="flex: 1;">
                <el-skeleton-item variant="p" style="width: 100%;" />
                <el-skeleton-item variant="p" style="width: 90%; margin-top: 10px;" />
                <el-skeleton-item variant="p" style="width: 80%; margin-top: 10px;" />
                <el-skeleton-item variant="p" style="width: 85%; margin-top: 10px;" />
                <el-skeleton-item variant="p" style="width: 75%; margin-top: 10px;" />
              </div>
            </div>
          </template>
        </el-skeleton>
      </el-card>
    </template>

    <!-- 通用骨架屏 -->
    <template v-else>
      <el-skeleton :rows="rows" animated />
    </template>
  </div>
</template>

<script setup>
defineProps({
  // 骨架屏类型: grid, list, detail, default
  type: {
    type: String,
    default: 'default'
  },
  // 行数/卡片数量
  rows: {
    type: Number,
    default: 6
  }
})
</script>

<style scoped lang="scss">
@use '@/styles/variables.scss' as *;

.loading-skeleton {
  .skeleton-card {
    margin-bottom: $spacing-lg;

    :deep(.el-card__body) {
      padding: 0;
    }
  }

  .skeleton-list {
    margin-bottom: $spacing-md;
  }
}
</style>
