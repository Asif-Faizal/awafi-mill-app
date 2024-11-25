import express from "express";
import { AdminReviewController } from "../controllers/adminReviewController"; 
import { AdminReviewInteractor } from "../../application/interactor/adminReviewInteractor"; 
import { AdminReviewRepository } from "../../infrastructure/repositories/adminReviewRepo";
import { ReviewModel } from "../../infrastructure/model/reviewModel";

// Set up dependencies
const reviewRepo = new AdminReviewRepository(ReviewModel);
const adminReviewInteractor = new AdminReviewInteractor(reviewRepo);
const adminReviewController = new AdminReviewController(adminReviewInteractor);

const adminReviewRoutes = express.Router();

// Define routes
adminReviewRoutes.get("/", adminReviewController.getAllReviews.bind(adminReviewController));
adminReviewRoutes.patch("/:reviewId/approve", adminReviewController.updateReviewStatus.bind(adminReviewController));
adminReviewRoutes.patch("/:reviewId/decline", adminReviewController.updateReviewStatus.bind(adminReviewController));

export default adminReviewRoutes;
