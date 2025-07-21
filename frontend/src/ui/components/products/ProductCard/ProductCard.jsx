import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import InfoIcon from '@mui/icons-material/Info';
import {
    Box,
    Button,
    Card,
    CardActions,
    CardContent,
    CardMedia,
    Typography
} from "@mui/material";

const ProductCard = ({ product }) => {
    const navigate = useNavigate();
    const { category } = useParams();
    const { id, website, productName, priceMkd, imageUrl } = product;

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

                {/* Price in MKD */}
                <Typography
                    variant="body1"
                    fontWeight="bold"
                    sx={{ textAlign: "right", fontSize: "1.25rem", mt: 1 }}
                >
                    {priceMkd.toLocaleString('en-US')} ден
                </Typography>
            </CardContent>

            <CardActions sx={{ justifyContent: "flex-end" }}>
                <Button
                    size="small"
                    color="info"
                    startIcon={<InfoIcon />}
                    onClick={() => navigate(`/products/${category}/${id}`)}
                >
                    Info
                </Button>
            </CardActions>
        </Card>
    );
};

export default ProductCard;
