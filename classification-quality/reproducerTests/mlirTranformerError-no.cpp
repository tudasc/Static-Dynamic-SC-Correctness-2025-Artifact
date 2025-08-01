#include <iostream>
#include <thread>



void incrementCounter() {
    thread_local static int counter = 0;
    counter++;
    std::cout << "Thread ID: " << std::this_thread::get_id()
              << " Counter: " << counter << std::endl;
}

int main() {
    std::thread t1([] {
        for (int i = 0; i < 3; ++i) incrementCounter();
    });

    std::thread t2([] {
        for (int i = 0; i < 3; ++i) incrementCounter();
    });

    t1.join();
    t2.join();

    return 0;
}