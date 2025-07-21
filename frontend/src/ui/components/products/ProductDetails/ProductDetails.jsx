// src/components/products/ProductDetails/ProductDetails.jsx
import React from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import useProductDetails from '../../../../hooks/useProductDetails.js';
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

const ProductDetails = () => {
    const { category, id } = useParams();
    const { product } = useProductDetails(id, category);
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
                Back to {category}
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
                                Specifications
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

            {/* Similar Products Button */}
            <Box sx={{ textAlign: 'center', mt: 3 }}>
                <Button
                    variant="contained"
                    size="large"
                    onClick={() => {
                        // TODO: implement similarity logic
                        navigate(`/products/${category}`);
                    }}
                    sx={{ px: 4, py: 2 }}
                >
                    Give me similar products depending on the characteristics
                </Button>
            </Box>
        </Box>
    );
};

export default ProductDetails;
