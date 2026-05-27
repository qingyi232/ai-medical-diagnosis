import request from './request'

export const getDocumentsApi = (params) => request.get('/knowledge', { params })

export const getDocumentApi = (id) => request.get(`/knowledge/${id}`)

export const createDocumentApi = (data) => request.post('/knowledge', data)

export const uploadDocumentApi = (formData) =>
  request.post('/knowledge/upload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
  })

export const vectorizeDocumentApi = (id) => request.post(`/knowledge/${id}/vectorize`)

export const updateDocumentApi = (id, data) => request.put(`/knowledge/${id}`, data)

export const deleteDocumentApi = (id) => request.delete(`/knowledge/${id}`)

export const getCategoriesApi = () => request.get('/knowledge/categories')
