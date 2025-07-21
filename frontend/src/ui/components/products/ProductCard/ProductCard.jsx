// src/components/products/ProductCard/ProductCard.jsx
import React from 'react'; // No need for useState, useParams, useNavigate here if they're not directly used for state/params in this component
import { useNavigate, useParams } from 'react-router-dom';
import InfoIcon from '@mui/icons-material/Info';
import {
    Box, // Not used, can be removed
    Button,
    Card,
    CardActions,
    CardContent,
    CardMedia,
    Typography
} from "@mui/material";

const ProductCard = ({ product }) => {
    const navigate = useNavigate();
    const { category } = useParams(); // category is needed for the navigate path

    // Destructure product properties.
    // Use default values or fallback to prevent errors if properties are missing.
    // Assuming 'price' might be the actual property name if 'priceMkd' is missing for similar products.
    // If 'priceMkd' is always the correct name, then the issue is truly undefined data.
    const { id, website, productName, imageUrl } = product;
    // Safely access priceMkd, assuming it might be 'price' for consistency
    // If 'priceMkd' is the actual field name, use `product.priceMkd` directly.
    const priceValue = product.priceMkd || product.price; // Try priceMkd, then fallback to price

    return (
        <Card sx={{ boxShadow: 3, borderRadius: 2, p: 1, maxWidth: 345 }}>
            {/* Product image */}
            <CardMedia
                component="img"
                height="180"
                image={imageUrl}
                alt={productName}
                sx={{ objectFit: 'contain' }}
            />

            <CardContent>
                {/* Website */}
                <Typography variant="subtitle2" color="text.secondary" gutterBottom>
                    {website}
                </Typography>

                {/* Name */}
                <Typography variant="h6" component="div" gutterBottom noWrap>
                    {productName}
                </Typography>

                {/* Price in MKD - Safely display price */}
                <Typography
                    variant="body1"
                    fontWeight="bold"
                    sx={{ textAlign: "right", fontSize: "1.25rem", mt: 1 }}
                >
                    {/* Check if priceValue exists and is a number before calling toLocaleString */}
                    {typeof priceValue === 'number' ? priceValue.toLocaleString('en-US') : 'N/A'} ден
                </Typography>
            </CardContent>

            <CardActions sx={{ justifyContent: "flex-end" }}>
                <Button
                    size="small"
                    color="info"
                    startIcon={<InfoIcon />}
                    onClick={() => navigate(`/products/${category}/${id}`)}
                >
                    ИНФО
                </Button>
            </CardActions>
        </Card>
    );
};

export default ProductCard;