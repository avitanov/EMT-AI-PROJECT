// src/components/products/ProductDetails/ProductDetails.jsx
import React from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import useProductDetails from "../../../hooks/useProductDetails.js";
import {
    Box,
    Button,
    CircularProgress,
    Grid,
    Typography,
    Card,
    CardContent,
    CardMedia,
    Divider,
    Table,
    TableBody,
    TableCell,
    TableContainer,
    TableRow
} from '@mui/material';
import { ArrowBack } from '@mui/icons-material';
import ProductsGrid from "../../components/products/ProductsGrid/ProductsGrid.jsx";

const ProductDetails = () => {
    const { category, id } = useParams();
    // Destructure new state variables
    const { product, similarProducts, fetchSimilar, isLoadingSimilar, hasFetchedSimilar } = useProductDetails(id, category);
    const navigate = useNavigate();

    if (!product) {
        return (
            <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '60vh' }}>
                <CircularProgress />
            </Box>
        );
    }

    const { website, productName, price, ImageUrl, specificationList = [] } = product;

    return (
        <Box>
            {/* Back link */}
            <Button
                startIcon={<ArrowBack />}
                onClick={() => navigate(`/products/${category}`)}
                sx={{ mb: 2 }}
            >
                Назад до {category}
            </Button>

            <Card sx={{ boxShadow: 3, borderRadius: 2 }}>
                <Grid container>
                    {/* Image */}
                    <Grid item xs={12} md={4}>
                        <CardMedia
                            component="img"
                            image={ImageUrl}
                            alt={productName}
                            sx={{ height: '100%', objectFit: 'contain', p: 2 }}
                        />
                    </Grid>

                    {/* Details & Specs */}
                    <Grid item xs={12} md={8}>
                        <CardContent>
                            <Typography variant="h4" gutterBottom sx={{ fontWeight: 600 }}>
                                {productName}
                            </Typography>
                            <Typography variant="subtitle2" color="text.secondary" gutterBottom>
                                {website}
                            </Typography>
                            <Typography variant="h5" color="primary.main" gutterBottom>
                                {Number(price).toLocaleString('en-US')} ден
                            </Typography>

                            <Divider sx={{ my: 2 }} />

                            <Typography variant="h6" gutterBottom>
                                Спецификации
                            </Typography>

                            <TableContainer>
                                <Table size="small" aria-label="specifications">
                                    <TableBody>
                                        {specificationList.map((spec) => (
                                            <TableRow
                                                key={spec.id}
                                                sx={{ '&:nth-of-type(odd)': { backgroundColor: 'action.hover' } }}
                                            >
                                                <TableCell>{spec.specificationText}</TableCell>
                                            </TableRow>
                                        ))}
                                    </TableBody>
                                </Table>
                            </TableContainer>
                        </CardContent>
                    </Grid>
                </Grid>
            </Card>

            {/* Similar Products Button and Feedback */}
            <Box sx={{ textAlign: 'center', mt: 3 }}>
                <Button
                    variant="contained"
                    size="large"
                    onClick={fetchSimilar}
                    sx={{ px: 4, py: 2 }}
                    disabled={isLoadingSimilar} // Disable button while loading
                >
                    {isLoadingSimilar ? <CircularProgress size={24} color="inherit" /> : "Прикажи продукти со слични карактеристики"}
                </Button>
            </Box>

            {/* Display Similar Products or Messages */}
            <Box sx={{ mt: 4 }}>
                {isLoadingSimilar ? (
                    <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '200px' }}>
                        <CircularProgress />
                        <Typography variant="h6" sx={{ ml: 2 }}>
                            Finding similar products...
                        </Typography>
                    </Box>
                ) : (
                    hasFetchedSimilar && ( // Only show if fetchSimilar has been called
                        similarProducts.length > 0 ? (
                            <>
                                <Typography variant="h5" gutterBottom sx={{ textAlign: 'center', mb: 3 }}>
                                    Слични продукти
                                </Typography>
                                <ProductsGrid products={similarProducts} />
                            </>
                        ) : (
                            <Typography variant="h6" sx={{ textAlign: 'center', color: 'text.secondary' }}>
                                Нема продукти со слични карактеристики 😔
                            </Typography>
                        )
                    )
                )}
            </Box>
        </Box>
    );
};

export default ProductDetails;