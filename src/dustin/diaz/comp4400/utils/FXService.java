package dustin.diaz.comp4400.utils;


import javafx.application.Platform;
import javafx.concurrent.Service;
import javafx.concurrent.Task;

import java.util.concurrent.CountDownLatch;

public class FXService<T> {

    private Service<T> service;
    private CountDownLatch latch;

    public FXService() {
    }

    public Service<T> setAll(Runnable runnable, CountDownLatch latch) {
        this.service = setRunnable(runnable);
        this.latch = latch;
        return this.service;
    }

    public Service<T> getService() {
        return service;
    }

    public void setService(Service<T> service) {
        this.service = service;
    }

    public CountDownLatch getLatch() {
        return latch;
    }

    public void countDown() {
        latch.countDown();
    }

    public void await() throws InterruptedException {
        latch.await();
    }

    public Service<T> setRunnable(Runnable runnable) {
        return new Service<T>() {
            @Override
            protected Task<T> createTask() {
                return new Task<T>() {
                    @Override
                    protected T call() throws Exception {
                        Platform.runLater(runnable);
                        latch.await();
                        return null;
                    }
                };
            }
        };
    }

    @Override
    public String toString() {
        return "FXService{" +
                "service=" + service +
                ", latch=" + latch +
                '}';
    }
}
