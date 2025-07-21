import React from 'react';
import ProductCard from "../ProductCard/ProductCard.jsx";
import {Grid} from "@mui/material";

const ProductsGrid = ({products}) => {
    return (
        <Grid container spacing={{xs: 2, md: 3}}>
            {products.map((product) => (
                <Grid key={product.id} size={{xs: 12, sm: 6, md: 4, lg: 3}}>
                    <ProductCard product={product}/>
                </Grid>
            ))}
        </Grid>
    );
};

export default ProductsGrid;