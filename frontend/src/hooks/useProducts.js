import {useCallback, useEffect, useState} from "react";
import productRepository from "../repository/productRepository.js";
const initialState = {
    "products": [],
    "loading": true,
};

const useProducts = (category) => {
    const [state, setState] = useState(initialState);

    const fetchFrizideri = useCallback(() => {
        setState(initialState);
        productRepository
            .findAllFrizideri()
            .then((response) => {
                setState({
                    "products": response.data,
                    "loading": false,
                });
            })
            .catch((error) => console.log(error));
    }, []);
    const fetchInverteri = useCallback(() => {
        setState(initialState);
        productRepository
            .findAllInverteri()
            .then((response) => {
                setState({
                    "products": response.data,
                    "loading": false,
                });
            })
            .catch((error) => console.log(error));
    }, []);


    useEffect(() => {
        if(category==="frizideri"){
            fetchFrizideri();
        }
        else if(category==="inverteri"){
            fetchInverteri()
        }
    }, [fetchFrizideri,fetchInverteri,category]);

    return {...state};
};

export default useProducts;