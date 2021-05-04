import matlab.engine
import numpy as np


class MyApp():
    def __init__(self):
        super().__init__()
        self.get_dataname_from_user()
        self.load_data()

    def get_dataname_from_user(self):
        self.data_to_load = input("filename: \n")
        self.num_of_init_center = int(input("number of initial centers: \n"))

    def load_data(self):
        self.data_for_matlab = np.loadtxt(self.data_to_load).tolist()
        self.show_data_in_console(self.data_for_matlab)

    def show_data_in_console(self, data):
        print("header: ")
        print(data[0:2])

    def run_kmeans_matlab(self):
        print("string matlab engine ...")
        matlab_engine = matlab.engine.start_matlab()
        print("matlab engine running ...")
        matlab_engine.kMeans2D(self.num_of_init_center,
                               self.data_for_matlab, 20)
        matlab_engine.quit()
        print("process complete.")


if __name__ == '__main__':
    app = MyApp()
    app.run_kmeans_matlab()
