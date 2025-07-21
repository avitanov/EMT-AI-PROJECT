import axiosInstance from "../axios/axios.js";

const productRepository = {
    findAllInverteri: async () => {
        return await axiosInstance.get("/products/inverteri");
    },
    findInverterById: async (id) => {
        return await axiosInstance.get(`/products/inverteri/${id}`);
    },
    findAllFrizideri: async () => {
        return await axiosInstance.get("/products/frizideri");
    },
    findFriziderById: async (id) => {
        return await axiosInstance.get(`/products/frizideri/${id}`);
    },
    findSimilarFrizider:async (id) => {
        return await axiosInstance.get(`/products/frizideri/${id}/findSimilar`);
    },
    findSimilarInverter:async (id) => {
        return await axiosInstance.get(`/products/inverteri/${id}/findSimilar`);
    }
};

export default productRepository;