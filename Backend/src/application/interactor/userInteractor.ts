// src/application/interactor/userInteractor.ts
// Declare a global variable to store user data, including OTP
let globalUserData: { email: string; password: string; otp?: string } | null =
  null;

const nullifyGlobalUserData = () => {
  globalUserData = null;
  console.log("Global User Data has been nullified.");
};

// userInteractor.ts
import { IUserInteractor } from "../../interface/userInterface/IuserInteractor";
import { IUserRepo } from "../../interface/userInterface/IuserRepo";
import { User } from "../../domain/entities/userSchema";
import { IBcrypt } from "../../interface/serviceInterface/IbcryptInterface";
import { generateOTP } from "../services/otpService";
import { UserInteractorResp } from "../../types/userTypes/userInteractorTypes";
import { Ijwt } from "../../interface/serviceInterface/IjwtInterface";


// userInteractor.ts

export class UserInteractor implements IUserInteractor {
  private userRepository: IUserRepo;
  private bcrypt: IBcrypt;
  private jwt:Ijwt;

  constructor(userRepository: IUserRepo, bcrypt: IBcrypt,jwt:Ijwt) {
    this.userRepository = userRepository;
    this.bcrypt = bcrypt;
    this.jwt = jwt;
  }

  //=-========================================login===============
  async login(email:string,password:string): Promise<UserInteractorResp> {
    try {
      const userData = await this.userRepository.findUser(email);
      if (!userData) {
        return { success: false, message: "User not found" };
      }
      const userLogin = await this.bcrypt.comparePassword(
        password,
        userData.password
      );
      if (userLogin) {
        const accessToken = this.jwt.generateToken({ id: userData.id }, "1h");
        return { success: true, message: "Login successful", data:accessToken};
      } else {
        return { success: false, message: "Invalid credentials" };
      }
    } catch (error) {
      console.log("error", error);
      throw new Error("Login failed");
    }
  }

 // src/application/interactor/userInteractor.ts

async registerUser(email: string, password: string): Promise<UserInteractorResp> {
  try {
    const userData = await this.userRepository.findUser(email);
    if (userData) {
      return { success: false, message: "User already registered" };
    }
    const otp = generateOTP();
    globalUserData = { email, password, otp };
    console.log("data", globalUserData);
    setTimeout(nullifyGlobalUserData, 300000); // Clear global data after 5 mins
    return { success: true, otp, message: "User registration initiated.." };
  } catch (error) {
    console.log("error", error);
    throw new Error("Registration failed");
  }
}

// Verify OTP and register new user
async verifyOtp(otp: string): Promise<UserInteractorResp> {
  if (globalUserData && otp === globalUserData.otp) {
    const hashedPassword = await this.bcrypt.encryptPassword(globalUserData.password);
    const newUser = User.newUser("some-id", "New User", globalUserData.email, hashedPassword); 
    await this.userRepository.registerUser(newUser);
    nullifyGlobalUserData();
    return { success: true, message: "User registered successfully." };
  } else {
    return { success: false, message: "Invalid OTP." };
  }
}

}
