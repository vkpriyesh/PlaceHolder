public class SwipeCounterService extends Service {
    private int swipeUpCount = 0;
    private int swipeDownCount = 0;
    private Date date;

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        date = new Date();
        GestureDetectorCompat gestureDetectorCompat = new GestureDetectorCompat(this, new SwipeGestureListener());
        View view = new View(this);
        view.setOnTouchListener((v, event) -> {
            gestureDetectorCompat.onTouchEvent(event);
            return true;
        });
        return START_STICKY;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    private class SwipeGestureListener extends GestureDetector.SimpleOnGestureListener {
        private static final int SWIPE_THRESHOLD = 100;
        private static final int SWIPE_VELOCITY_THRESHOLD = 100;

        @Override
        public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX, float velocityY) {
            boolean result = false;
            try {
                float diffY = e2.getY() - e1.getY();
                float diffX = e2.getX() - e1.getX();
                if (Math.abs(diffX) > Math.abs(diffY)) {
                    if (Math.abs(diffX) > SWIPE_THRESHOLD && Math.abs(velocityX) > SWIPE_VELOCITY_THRESHOLD) {
                        if (diffX > 0) {
                            onSwipeRight();
                        } else {
                            onSwipeLeft();
                        }
                        result = true;
                    }
                } 
                else if (Math.abs(diffY) > SWIPE_THRESHOLD && Math.abs(velocityY) > SWIPE_VELOCITY_THRESHOLD) {
                    if (diffY > 0) {
                        onSwipeDown();
                    } else {
                        onSwipeUp();
                    }
                    result = true;
                }
            } catch (Exception exception) {
                exception.printStackTrace();
            }
            return result;
        }
    }

    public void onSwipeRight() {
    }

    public void onSwipeLeft() {
    }

    public void onSwipeUp() {
        swipeUpCount++;
        checkCount();
    }

    public void onSwipeDown() {
        swipeDownCount++;
        checkCount();
    }

    private void checkCount() {
        if (new Date().getDay() != date.getDay()) {
            // reset the count if a new day has started
            swipeUpCount = 0;
            swipeDownCount = 0;
            date = new Date();
        }
    }
}
