<template>
  <div className="volunteerPersonal">
    <!-- Main content -->
    <el-main class="main-content">
      <div class="user-profile">
        <img :src="userStore.user.photo" class="user-avatar">
        <div class="username">{{ userStore.user.username }}</div>
      </div>
      <div class="user-rating">
        <el-rate v-model="rating"></el-rate>
      </div>
      <el-row :gutter="20" class="feature-row">
        <el-col :span="24" :md="8" v-for="feature in features" :key="feature.name">
          <el-card class="feature-card" @click="navigateTo(feature.route)">
            <div class="card-content">
              <img :src="feature.icon" class="feature-icon" alt="Feature Icon">
              <h3>{{ $t(feature.name) }}</h3>
              <p>{{ feature.description }}</p>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </el-main>
  </div>
</template>

<script>
//todo: change to vue3 setup
import useUser from "../../store/user";
// user store
const userStore = useUser();

export default {
  name: 'VolunteerMainPage',
  data() {
    return {
      userStore,
      rating: 4.5,
      features: [
        {
          name: 'personal.personalInformation',
          icon: './src/assets/personal.png',
          route: '/volunteer/personalInfo',
        },
        {
          name: 'personal.credentials',
          icon: './src/assets/credentials.png',
          route: '/volunteer/credentials',
        },
        {
          name: 'personal.events',
          icon: './src/assets/events.png',
          route: '/volunteer/events_volunteer',
        },
        {
          name: 'personal.comments',
          icon: './src/assets/comments.png',
          route: '/volunteer/comments',
        },
        {
          name: 'personal.information',
          icon: './src/assets/message.png',
          route: '/volunteer/information',
        },
        {
          name: 'personal.share',
          icon: './src/assets/share.png',
          route: '/volunteer/share',
        }
      ]
    };
  },
  methods: {
    navigateTo(route) {
      this.$router.push(route);
    }
  }
};
</script>

<style scoped>
.main-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  margin-bottom: 20px;
  color: #a9181a;; /* 设置文本颜色为深灰色 */
}

.user-profile {
  margin-bottom: 10px;
  width: 100%; /* 确保占满整个容器宽度 */
  display: flex;
  flex-direction: column;
  align-items: center; /* 保证子元素居中 */
}

.username {
  margin-top: 10px; /* 根据需要调整间距 */
  text-align: center; /* 确保文本居中显示 */
  color:  #a9181a;;
  font-size: 15px;
}

.user-avatar {
  width: 50px; /* 设置头像宽度 */
  height: 50px; /* 设置头像高度 */
  border-radius: 50%; /* 保持圆形 */
  object-fit: cover; /* 使图片覆盖整个区域，多余的部分会被剪裁掉 */
  border: 2px solid  #a9181a;; /* 为头像添加边框 */
}

.user-rating {
  margin-top: 0px;
}

.feature-row {
  width: 100%;
}

.feature-card {
  cursor: pointer;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 20px;
  margin-top: 10px;
  margin-bottom: 15px;
  border: 1px solid #ccc;
  background-color: #f5f5f5;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
  border-radius: 10px;
}
.feature-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.feature-icon {
  width: 40px;
  height: 40px;
  margin-bottom: 10px;
}

.card-content {
  text-align: center;
}

.feature-card h3 {
  margin-top: 10px;
}

.feature-card p {
  color:  #a9181a;;
  font-size: 14px;
}

/* 基本样式不变 */

@media (max-width: 600px) {
  .main-content {
    padding: 10px; /* 调整内边距为10px */
  }

  .username {
    font-size: 18px; /* 将字体大小调整为18px */
    padding: 0 10px; /* 增加左右的内边距 */
    margin-bottom: 10px; /* 增加与下方元素的间距 */
  }

  .user-avatar {
    width: 80px; /* 将头像宽度调整为80px */
    height: 80px; /* 将头像高度调整为80px */
  }

  .user-rating {
    margin-bottom: 20px; /* 减少与下方元素的间距 */
  }

  .feature-row {
    margin: 0 5px; /* 减少特性行的外边距 */
  }

  .feature-card {
    cursor: pointer;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    border: 2px dashed  #a9181a;;
    padding: 15px;
    margin: 10px auto; /* 确保卡片居中且有足够的外边距 */
    width: calc(100% - 20px); /* 减去外边距确保完整显示边框 */
    box-sizing: border-box; /* 包含padding和border在内的宽度计算 */
  }

  .feature-icon {
    width: 25px;
    height: 25px;
  }

  .feature-card h3 {
    font-size: 16px; /* 适当调整以适应显示 */
    margin: 5px 0; /* 减少标题与其他元素的间距 */
  }

  .feature-card p {
    font-size: 14px; /* 适当调整字体大小以适应空间 */
    margin: 0 0 5px; /* 调整段落的间距 */
    text-align: center; /* 确保文本居中对齐 */
    word-wrap: break-word; /* 避免文字溢出 */
  }
}
</style>
