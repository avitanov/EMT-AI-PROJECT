import React from 'react';
import {Box, CircularProgress,Typography,Stack,Button} from "@mui/material";
import ProductsGrid from "../components/products/ProductsGrid/ProductsGrid.jsx";
import useProducts from "../../hooks/useProducts.js";
import "./ProductsPage.css";
import { useParams,useNavigate} from "react-router";

const ProductsPage = () => {
    const {category} = useParams();
    const {products, loading} = useProducts(category);
    const navigate=useNavigate();

    if(!category){
        return (
            <Box
                sx={{
                    minHeight: '80vh',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    color: 'black',
                    p: 2,
                }}
            >
                <Box
                    sx={{
                        textAlign: 'center',
                        backdropFilter: 'blur(8px)',
                        backgroundColor: 'rgba(255,255,255,0.12)',
                        borderRadius: 2,
                        p: 4,
                        maxWidth: 480,
                        width: '100%',
                        animation: 'fadeIn 0.8s ease-out',
                    }}
                >
                    <Typography variant="h3" component="h1" gutterBottom>
                        Добредојде!
                    </Typography>
                    <Typography variant="subtitle1" gutterBottom>
                        Избери категорија за да ги разгледаш нашите производи.
                    </Typography>
                    <Stack
                        direction={{ xs: 'column', sm: 'row' }}
                        spacing={2}
                        justifyContent="center"
                        sx={{ mt: 3 }}
                    >
                        <Button
                            variant="contained"
                            size="large"
                            onClick={() => navigate('/products/frizideri')}
                            sx={{ backgroundColor: '#ffcc00', color: '#000' }}
                        >
                            Фрижидери
                        </Button>
                        <Button
                            variant="contained"
                            size="large"
                            onClick={() => navigate('/products/inverteri')}
                            sx={{ backgroundColor: '#00ccff', color: '#000' }}
                        >
                            Инвертери
                        </Button>
                    </Stack>
                </Box>
            </Box>
        );
    }
    else{
        return (
            <>
                <Box className="products-box">
                    {loading && (
                        <Box className="progress-box">
                            <CircularProgress/>
                        </Box>
                    )}
                    {!loading &&
                        <>
                            <ProductsGrid products={products}/>
                        </>}
                </Box>
            </>
        );
    }

};

export default ProductsPage;