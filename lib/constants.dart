List<String> categoriesList = [
  'Coming Soon',
  'Now Playing',
  'Top Rated',
  // 'Trending',
  'Popular',
];

List<String> tvShowCategoriesList = [
  'On-Air',
  'Playing today',
  'Popular',
  'Top Rated',
];

List<String> genresList = [
  'All',
  'Action',
  'Animation',
  'Comedy',
  'Romance',
  'Science Fiction',
  'War',
  'Horror'
];

Map<int,String>genresMap={
  0:'All',
  28:'Action',
  16:'Animation',
  35:'Comedy',
  10749:'Romance',
  878:'Science Fiction',
  10752:'War',
  27:'Horror',
};

String imageTmdbApiLink='https://image.tmdb.org/t/p/w500';
String errorImageUrl = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAAAKlBMVEXk5ueutLfo6uupsLPg4uPZ3N3U19jJzc+2u76orrLO0dO8wcPAxcfDx8oF30/pAAAE0klEQVR4nO2d2ZasIAxFJajg9P+/ex1q6m7rlkCQEyv7pVf3k3sFEgZNV5WiKIqiKIqiKIqiKIqiKIqiKIqiKIqiKIqiKIqiKBeEiKq6afuFtll/vRCzTeu8sZ290Vnjp7a6iiXVvbfW/MFa72r5kkT7eg/JvhLtSOTe690lJ8GOn/1Wx06qI7XmgN8Wx16gIlX+oN/q6GtpjtQG+K2OwsJIU6DgrDiIUgwZoQ9FU/qpAwjX2xwbIWGsIwIoSjFeUIpiguCiWPrxP5PityiWfv5PkE80NAZ7nNKYNEbXIELXxeCVzK6iQ1ZkEDSmw802DJNwAzWI1LOEEHmcMgnOinVplV0i9hNv8ZhB7NgEMZc2NPAJYgaxZgwhZBA5Z+ECYBB5BU2Hlk7ZauEdO4EFkW058wTMMGVjv49tSzv9gBy7oRmhgphhkBoLZcidSRewNlEcO9/fWFfa6gWa+AWxin6OaYg1EYl1TfowBFrW8FfD1RCoIuZINFiHGS6HIFLNz5NKkZIp7/Ye0jBLsTBA2wvKJIhz7Z3LEOemTQ3V8HsNgTLN9avF9St++u09uOH1V95fsHvivXd6GALtgK9/ipGnIEKdRI05DIFSaaZUg3Qi/AWn+te/mbn+7dr1b0gzDFOsQfoNbyqwZ1OkBc0Gd9GHKvcbvLkG8K2vL3hzj3ULhRhC3rMMyBBWjOkU7rW9G3xvsuPVwhuX/xqBq2JgppkNlnGKdMT2FxrSFVHz6I30MymcC6d3pAqCFooX0rIN1uHMG5qUL51b7Em4QfGKMgSr+IHaifhWfSOma4Qx+EnmScQ+w/rSDx1G8OoGeyWzR2AHHiOuA0+1hvGoo7wAbhBNhxztKLQTVrUM1Y+O1o4SB+gTqnrf/acjnXFy43eHqHZvugqaqZHfVXBl6Qw5+W5pDLmp2a7zY3+BpomvLO08l+aezi3dPeuLdff8CmiH0s/EAt1bz7pxGLzfThvnn34YJ3cbrWJN50evWzd4s7Wd3Uml29/91DfiutEuSaUfTfe+EP5QXdrvetdKSa1bz+C9oH0StUZAASFq9qt7gGWLu8iZ9SaToPew9D3iSnXWG9Pt7pIdXANlqtzRjrqHJYcWZk4StQNb+F4lQfYd8/aIOXwvjnYsfr54YIubKOmLOs7TL69fYccDDddlOwYcpaU7DudXSGriDu6jHadzawdVDLfZgYrmzHspljal4Y7DWeUx7Lye1fGczvRlAnhTHM4QZO6tF6hocheOciP04Zh3pCZc0fMp5uwVTX2Wr/ACyfg/FMpOwVcyrXA43lljIs8/GAASzKNIpZPoT/hfvQET5FeEGqIbvAM1V9OEJDjf08zx/SQHfIItQqHfge196Tw9AxmwTB/SZuuvkw7PMhwwjT7hyDYlN7wH4JiK0IIM7/zlapDERvI4bUALxZPEcQqcR++kdSZg/8o+B0mtCUiAYFJRRF2P/iIhiCJCmBJEEbNwJdqw9IMfJTqdAhz/HiSyJuZp4JWF2IWNmBDGrk6xNxU/iRqmggZp5DAVk0kXbB9hCHs6s0vMlZuYcr8SsXITNQ2j+r2ImoZRy5o8TVfzEd4oU1aiiUk1kur9QnjNl5VKTcQOynVWFF2o4P7XZsiEGyqKoiiKoiiKoiiKoihn8g8ITEwsG8b5AAAAAABJRU5ErkJggg==';