import ICategoryInteractor from "../../interface/subCategoryInterface/IsubCategoryInteractory";
import { LargeDataFetch, responseHandler } from "../../types/commonTypes";
import IsubCategoryRepo from "../../interface/subCategoryInterface/IsubCategoryRepo"; // Import your category repository interface
import {subCategoryCreationDTo,subCategoryDTo} from '../../domain/dtos/SubCategoryDTO'
import IsubCategoryInteractor from "../../interface/subCategoryInterface/IsubCategoryInteractory";
import mongoose from "mongoose";
import { ICloudinaryService } from "../../interface/serviceInterface/IcloudinaryInterface";
import IsubCategory from "../../domain/entities/subCategorySchema";


export class SubCategoryInteractor implements IsubCategoryInteractor {
  private categoryRepo: IsubCategoryRepo; // Use the category repository
  private cloudService:ICloudinaryService;
  

  constructor(categoryRepo: IsubCategoryRepo,cloudService:ICloudinaryService) {
    this.categoryRepo = categoryRepo;
    this.cloudService=cloudService
  }

  // Add a new category
  async addCategory(data:subCategoryCreationDTo): Promise<subCategoryDTo |responseHandler> {
    // console.log("data",data)
    const{name}=data
    const isAvailable=await this.categoryRepo.findByName(name)
    if(isAvailable)
    {
      return { message: "Category always in your bucket", status: 409 };

    }
    if(data && data.photo)
      {
        const uploadImage=await this.cloudService.uploadSubCategoryImage(data.photo)
        data.photo=uploadImage.secure_url
  
      }
    const category = await this.categoryRepo.addCategory(data); // Use repository method

    return this.mapToDTO(category);
  }

  // Get all categories
  async getAllCategories(page:number,limit:number): Promise<LargeDataFetch> {
    const categoryResponse = await this.categoryRepo.getAllCategories(page,limit); // Use repository method
    const categories=categoryResponse.data.map(this.mapToDTO);
    return {data:categories,totalPages:categoryResponse.totalPages}
}
  async searchByname(page:number,limit:number,name:string): Promise<LargeDataFetch> {
    const categoryResponse = await this.categoryRepo.findCategoryName(page,limit,name); // Use repository method
    const categories=categoryResponse.data.map(this.mapToDTO);
    return {data:categories,totalPages:categoryResponse.totalPages}
}

  // Get all listed categories
  async getListedCategories(mainCategoryId:mongoose.Types.ObjectId,page:number,limit:number): Promise<LargeDataFetch> {
    const categoryResponse = await this.categoryRepo.getListedCategories(mainCategoryId,page,limit); // Use repository method
    const categories= categoryResponse.data.map(this.mapToDTO);
    return {data:categories,totalPages:categoryResponse.totalPages}
  }

  // Get a category by ID
  async getCategoryById(id: mongoose.Types.ObjectId): Promise<subCategoryDTo | null> {
    const category = await this.categoryRepo.getCategoryById(id); // Use repository method
    return category && !category.isDeleted ? this.mapToDTO(category) : null;
  }

  // Update a category
  async updateCategory(categoryId: mongoose.Types.ObjectId, data: Partial<subCategoryCreationDTo>): Promise<subCategoryDTo | responseHandler | null> {
    if(data.name)
    {
      const isAvailable=await this.categoryRepo.findByNameNotId(categoryId,data.name)
      if(isAvailable)
      {
        return { message: "Category always in your bucket", status: 409 };
  
      }

    }
    if(data.photo)
      {
        const uploadImage=await this.cloudService.uploadSubCategoryImage(data.photo)
        data.photo=uploadImage.secure_url
  
      }
   
    const updatedCategory = await this.categoryRepo.updateCategory(categoryId, data); // Use repository method
    return updatedCategory && !updatedCategory.isDeleted ? this.mapToDTO(updatedCategory) : null;
  }

  // Soft delete a category
  async deleteCategory(id: mongoose.Types.ObjectId): Promise<boolean> {
    return await this.categoryRepo.deleteCategory(id); // Use repository method
  }

  // List a category
  async listById(id: mongoose.Types.ObjectId): Promise<responseHandler | null> {
    const category = await this.categoryRepo.getCategoryById(id); // Use repository method
    if (category && !category.isDeleted) {
      if (category.isListed) {
        throw new Error("Category is already listed.");
      }
      category.isListed = true; // List the category
      await this.categoryRepo.updateCategory(id, this.mapToDTO(category)); // Use repository method to update
      return { message: "Category listed successfully" };
    }
    throw new Error("Category not found.");
  }

  // Unlist a category
  async unListById(id: mongoose.Types.ObjectId): Promise<responseHandler | null> {
    const category = await this.categoryRepo.getCategoryById(id); // Use repository method
    if (category && !category.isDeleted) {
      if (!category.isListed) {
        throw new Error("Category is already unlisted.");
      }
      category.isListed = false; // Unlist the category
      await this.categoryRepo.updateCategory(id, this.mapToDTO(category)); // Use repository method to update
      return { message: "Category unlisted successfully" };
    }
    throw new Error("Category not found.");
  }

  async availblePrioritySlots(): Promise<{priorities:number[] |[]}> {
    const maxPriorities = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  
    // Fetch all listed categories
    const categoriesResponse = await this.categoryRepo.getAllCategories(0, 0);
  
    // Extract existing priorities
    const existingPriorities = categoriesResponse.data
      .map((ele) => ele.priority)
      .filter((priority) => typeof priority === "number" && priority !=101); // Filter out invalid values
  
    // Find missing priorities
    const missingPriorities = maxPriorities.filter(
      (priority) => !existingPriorities.includes(priority)
    );
  
  
  
    // Return the mapped category data along with priorities
  
    return  {priorities: missingPriorities}
  
  }
  

  // Map Category to ProductDTO
  private mapToDTO(category: IsubCategory): subCategoryDTo {
    return {
      _id: category._id,
      name: category.name,
      description: category.description,
      mainCategory:category.mainCategory,
      isListed: category.isListed,
      isDeleted: category.isDeleted,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
      photo:category.photo,
      priority:category.priority
    };
  }
}
