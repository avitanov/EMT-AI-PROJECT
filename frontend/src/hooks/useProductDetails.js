import {useEffect, useState} from "react";
import productRepository from "../repository/productRepository.js";

const useProductDetails = (id,category) => {
    const [state, setState] = useState({
        "product": null,
    });

    useEffect(() => {
        if(category==="frizideri"){
            productRepository
                .findFriziderById(id)
                .then((response) => {
                    setState(prevState => ({...prevState, "product": response.data}));
                })
                .catch((error) => console.log(error));
        }
        else{
            productRepository
                .findInverterById(id)
                .then((response) => {
                    setState(prevState => ({...prevState, "product": response.data}));
                })
                .catch((error) => console.log(error));

        }

    }, [id]);

    return state;
};

export default useProductDetails;