<template>
  <div>
    <vue-cal
        v-model="calendarDate"
        :events="events"
        @cell-click="handleCellClick"
    ></vue-cal>
  </div>
</template>

<script setup lang='ts'>
import {ref, onMounted, getCurrentInstance, watch} from 'vue';
import VueCal from 'vue-cal';
import 'vue-cal/dist/vuecal.css'; // 引入 vue-cal 的样式

const { proxy } = getCurrentInstance();

interface Event {
  id: number;
  organizerId: number;
  title: string;
  description: string;
  location: string;
  startDate: string; // 新的开始时间字段
  endDate: string; // 新的结束时间字段
  status: string;
  notifications: string;
  pointsAwarded: number;
}

const calendarDate = ref(new Date());
const events = ref([
  {
    id: 1,
    title: 'event1',
    start: '2024-07-12 10:00',
    end: '2024-07-12 12:00'
  },
  {
    id: 2,
    title: 'event2',
    start: '2024-07-13 14:00',
    end: '2024-07-13 16:00'
  }
]);
function convertToCustomFormat(isoString : any) {
  const date = new Date(isoString);

  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');

  return `${year}-${month}-${day} ${hours}:${minutes}`;
}
const fetchEvents = async (month: number, year: number) => {
  try {
    const response = await proxy.$api.getEventsByDate({ month, year });
    events.value = response.map(event => ({
      id: event.id,
      start: convertToCustomFormat(event.startDate),
      end: convertToCustomFormat(event.endDate),
      title: event.title // 确保事件有 title 字段
    }));
    console.log("fetchEvents : events :", events);
  } catch (error) {
    console.error("Error fetching events:", error);
  }
};

const handlePanelChange = (date: Date) => {
  console.log("handlePanelChange date:", date);
  const month = date.getMonth() + 1;
  const year = date.getFullYear();
  // fetchEvents(month, year);
};

const handleCellClick = (date) => {
  console.log('Cell clicked:', date);
};

onMounted(() => {
  console.log("onMounted")
  console.log("initial events :", events);

  const month = calendarDate.value.getMonth() + 1;
  const year = calendarDate.value.getFullYear();
  fetchEvents(month, year);
});
watch(calendarDate, (newDate) => {
  console.log("watch calendarDate")
  const month = newDate.getMonth() + 1;
  const year = newDate.getFullYear();
  // fetchEvents(month, year);
});
</script>

<style>
/* 添加一些自定义样式以适应你的布局 */
.vuecal__event {
  background-color: #409EFF;
  color: #ffffff;
  border-radius: 4px;
  padding: 4px;
  margin: 2px 0;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}
</style>
