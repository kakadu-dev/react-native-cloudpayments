import { NativeModules } from 'react-native';

const RNCloudPaymentsModule = NativeModules.RNCloudPayments;

export default class RNCloudPayments {
  static async isValidNumber(cardNumber) {
    try {
      return await RNCloudPaymentsModule.isValidNumber(cardNumber);
    } catch(error) {
      return createError(error);
    }
  }

  static async isValidExpired(cardExp) {
	try {
		return await RNCloudPaymentsModule.isValidExpired(cardExp);
	} catch(error) {
		return createError(error);
	}
  }

  static async getType(cardNumber, cardExp, cardCvv) {
    try {
      return await RNCloudPaymentsModule.getType(cardNumber, cardExp, cardCvv);
    } catch(error) {
      return createError(error);
    }
  }

  static async createCryptogram(cardNumber, cardExp, cardCvv, publicId) {
    try {
      return await RNCloudPaymentsModule.createCryptogram(cardNumber, cardExp, cardCvv, publicId);
    } catch(error) {
      return createError(error);
    }
  }

  static async show3DS(acsUrl, paReq, transactionId) {
	try {
		return await RNCloudPaymentsModule.show3DS(acsUrl, paReq, transactionId);
	} catch(error) {
		return createError(error);
	}
  }
}

class RNCloudPaymentsError extends Error {
  constructor(details) {
    super();

    this.name = 'RNCloudPaymentsError';
    this.message = typeof details === 'string' ? details : details.message;
  }
}

function createError(error) {
  return new RNCloudPaymentsError(error);
}
