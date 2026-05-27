import request from './request'

export const generatePlanApi = (data) => request.post('/plans/generate', data)

export const analyzeApi = (data) => request.post('/plans/analyze', data)

export const searchKnowledgeApi = (data) => request.post('/plans/search', data)

export const getPlansApi = (params) => request.get('/plans', { params })

export const getPlanApi = (id) => request.get(`/plans/${id}`)

export const submitFeedbackApi = (id, data) => request.post(`/plans/${id}/feedback`, data)

export const deletePlanApi = (id) => request.delete(`/plans/${id}`)

export const exportPlanApi = (id) => request.get(`/plans/${id}/export`, { responseType: 'blob' })
