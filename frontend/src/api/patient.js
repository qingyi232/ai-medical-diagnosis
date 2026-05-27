import request from './request'

export const getPatientsApi = (params) => request.get('/patients', { params })

export const getPatientApi = (id) => request.get(`/patients/${id}`)

export const createPatientApi = (data) => request.post('/patients', data)

export const updatePatientApi = (id, data) => request.put(`/patients/${id}`, data)

export const deletePatientApi = (id) => request.delete(`/patients/${id}`)

export const getPatientRecordsApi = (patientId, params) =>
  request.get(`/patients/${patientId}/records`, { params })

export const getAllRecordsApi = (params) => request.get('/patients/records', { params })

export const getRecordApi = (id) => request.get(`/patients/records/${id}`)

export const createRecordApi = (patientId, data) =>
  request.post(`/patients/${patientId}/records`, data)

export const updateRecordApi = (id, data) => request.put(`/patients/records/${id}`, data)

export const deleteRecordApi = (id) => request.delete(`/patients/records/${id}`)
