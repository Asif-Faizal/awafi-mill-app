import express from "express";

import { AdminController } from "../controllers/adminController";
import { AdminInteractor } from "../../application/interactor/adminInteractor";
import { UserRepo } from "../../infrastructure/repositories/userRepo";
import { JWT } from "../../application/services/jwtService";
import { verifyAdminToken } from "../middleware/adminAuthMiddleware";

const userRepository = new UserRepo()
const jwt = new JWT()


const adminInteractor = new AdminInteractor(userRepository,jwt)
const adminController = new AdminController(adminInteractor)


const adminRoute = express.Router();
adminRoute.post('/login',adminController.adminLogin.bind(adminController))
//auth routes used middleware
adminRoute.use(verifyAdminToken); 
adminRoute.get('/allUser',adminController.allUsers.bind(adminController))
adminRoute.post('/blockUser',adminController.blockUser.bind(adminController))
adminRoute.post('/unblockUser',adminController.unblockUser.bind(adminController))
//dash data







export default adminRoute;