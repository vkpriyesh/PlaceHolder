import React, { useState, useEffect } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import Swipeable from 'react-native-swipeable';
import axios from 'axios';

const API_URL = 'https://hacker-news.firebaseio.com/v0/';

export default function App() {
  const [stories, setStories] = useState([]);

  useEffect(() => {
    axios.get(`${API_URL}topstories.json`)
      .then(res => {
        const topStoryIds = res.data.slice(0, 10); // Change this to the number of stories you want to display
        const promises = topStoryIds.map(id =>
          axios.get(`${API_URL}item/${id}.json`)
            .then(res => res.data)
        );
        return Promise.all(promises);
      })
      .then(data => setStories(data))
      .catch(err => console.log(err));
  }, []);

  const [swipeable, setSwipeable] = useState(null);

  const handleSwipe = () => {
    swipeable.recenter();
  };

  return (
    <View style={styles.container}>
      {stories.map(story => (
        <Swipeable
          key={story.id}
          onSwipeRelease={handleSwipe}
          onRef={ref => setSwipeable(ref)}
          rightContent={<Text style={styles.rightText}>Delete</Text>}
        >
          <View style={styles.card}>
            <Text style={styles.cardTitle}>{story.title}</Text>
            <Text style={styles.cardText}>{story.by}</Text>
          </View>
        </Swipeable>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'stretch',
    justifyContent: 'center',
    padding: 20,
  },
  card: {
    backgroundColor: '#f5f5f5',
    borderRadius: 5,
    padding: 20,
    marginBottom: 10,
  },
  cardTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  cardText: {
    fontSize: 14,
  },
  rightText: {
    backgroundColor: 'red',
    color: 'white',
    padding: 20,
  },
});
